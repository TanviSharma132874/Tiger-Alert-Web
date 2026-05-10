import cv2
import time
import requests
from ultralytics import YOLO
import pygame
import os
import mysql.connector
import numpy as np
import torch
import torchvision.models as models
import torchvision.transforms as transforms
from PIL import Image
from sklearn.metrics.pairwise import cosine_similarity
import uuid

print("🐅 Tiger Detection Script Started")

# ==============================
# CONFIG
# ==============================
CAMERA_ID = "1"
SERVER_URL = "http://localhost:8081/TigerAlertWeb/AutoAlertServlet"
COOLDOWN_SECONDS = 5
SIMILARITY_THRESHOLD = 0.65

MODEL_PATH = r"C:\Users\tanvi\Downloads\archive\tigers\runs\detect\train\weights\best.pt"
SAVE_DIR = r"C:\TigerAlertWeb\detected_images"
os.makedirs(SAVE_DIR, exist_ok=True)

DB_CONFIG = {
    "host": "127.0.0.1",
    "user": "root",
    "password": "",
    "database": "tiger_alert",
    "port": 3306
}

# ==============================
# SOUND
# ==============================
pygame.mixer.init()
siren_sound = pygame.mixer.Sound("siren.mp3")
warning_sound = pygame.mixer.Sound("warning.mp3")

# ==============================
# LOAD MODELS
# ==============================
model = YOLO(MODEL_PATH)
print("✅ YOLO Model loaded")
print("Model classes:", model.names)

resnet = models.resnet50(weights=models.ResNet50_Weights.DEFAULT)
resnet = torch.nn.Sequential(*(list(resnet.children())[:-1]))
resnet.eval()

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
])

# ==============================
# LOAD EMBEDDINGS
# ==============================
def load_embeddings():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute("SELECT tiger_id, embedding FROM tigers WHERE embedding IS NOT NULL")

    tiger_embeddings = {}
    rows = cursor.fetchall()
    print("Loaded embeddings:", len(rows))

    for tiger_id, emb in rows:
        emb_array = np.array(list(map(float, emb.split(","))), dtype=np.float32)
        norm = np.linalg.norm(emb_array)
        if norm != 0:
            emb_array = emb_array / norm
        tiger_embeddings[tiger_id] = emb_array

    cursor.close()
    conn.close()
    return tiger_embeddings

# ==============================
# GENERATE EMBEDDING
# ==============================
def generate_embedding(image):
    image = Image.fromarray(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
    image = transform(image).unsqueeze(0)

    with torch.no_grad():
        embedding = resnet(image)

    embedding = embedding.squeeze().numpy().astype(np.float32)

    norm = np.linalg.norm(embedding)
    if norm != 0:
        embedding = embedding / norm

    return embedding

# ==============================
# MATCH TIGER
# ==============================
def find_best_match(new_embedding):
    stored_embeddings = load_embeddings()

    if len(stored_embeddings) == 0:
        return None, 0

    best_match_id = None
    best_score = 0

    for tiger_id, emb in stored_embeddings.items():
        score = cosine_similarity(
            new_embedding.reshape(1, -1),
            emb.reshape(1, -1)
        )[0][0]

        if score > best_score:
            best_score = score
            best_match_id = tiger_id

    if best_score >= SIMILARITY_THRESHOLD:
        return best_match_id, best_score

    return None, best_score

# ==============================
# CAMERA LOOP
# ==============================
cap = cv2.VideoCapture(0)
last_detection_time = 0

while True:
    ret, frame = cap.read()

    if not ret:
        print("❌ Camera error")
        break

    current_time = time.time()

    if current_time - last_detection_time < COOLDOWN_SECONDS:
        cv2.imshow("Tiger CCTV Monitor", frame)
        if cv2.waitKey(1) & 0xFF == 27:
            break
        continue

    results = model(frame, conf=0.35, verbose=False)

    detection_done = False

    for r in results:
        for box in r.boxes:

            confidence = float(box.conf[0])
            class_id = int(box.cls[0])
            class_name = model.names[class_id]

            if class_name.lower() != "tiger":
                continue

            x1, y1, x2, y2 = map(int, box.xyxy[0])
            tiger_crop = frame[y1:y2, x1:x2]

            if tiger_crop.size == 0:
                continue

            img_name = f"tiger_{uuid.uuid4().hex}.jpg"
            img_path = os.path.join(SAVE_DIR, img_name)
            cv2.imwrite(img_path, tiger_crop)

            print("📸 Image saved:", img_path)

            if confidence >= 0.7:
                siren_sound.play()
            else:
                warning_sound.play()

            new_embedding = generate_embedding(tiger_crop)
            tiger_id, similarity = find_best_match(new_embedding)

            # 🆕 NEW TIGER LOGIC
            is_new_tiger = False

            if tiger_id:
                print(f"🎯 Auto matched Tiger ID: {tiger_id} (Score: {similarity:.3f})")
            else:
                print(f"🆕 NEW TIGER DETECTED (Score: {similarity:.3f})")
                is_new_tiger = True

            data = {
                "camera_id": CAMERA_ID,
                "confidence": confidence,
                "image_name": img_name
            }

            if tiger_id:
                data["tiger_id"] = tiger_id
            else:
                data["new_tiger"] = "true"

            try:
                response = requests.post(SERVER_URL, data=data, timeout=10)
                print("Server response:", response.status_code)
            except Exception as e:
                print("Server error:", e)

            last_detection_time = current_time
            detection_done = True
            break

        if detection_done:
            break

    cv2.imshow("Tiger CCTV Monitor", frame)

    if cv2.waitKey(1) & 0xFF == 27:
        break

cap.release()
cv2.destroyAllWindows()
pygame.mixer.quit()
print("🛑 Detection stopped")