import sys
import torch
import torchvision.models as models
import torchvision.transforms as transforms
from PIL import Image
import numpy as np
import mysql.connector

DB_CONFIG = {
    "host": "127.0.0.1",
    "user": "root",
    "password": "",
    "database": "tiger_alert",
    "port": 3306
}

resnet = models.resnet50(weights=models.ResNet50_Weights.DEFAULT)
resnet = torch.nn.Sequential(*list(resnet.children())[:-1])
resnet.eval()

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
])

def generate_embedding(image_path):
    img = Image.open(image_path).convert("RGB")
    img = transform(img).unsqueeze(0)

    with torch.no_grad():
        features = resnet(img)

    embedding = features.squeeze().numpy().astype(np.float32)

    norm = np.linalg.norm(embedding)
    if norm != 0:
        embedding = embedding / norm

    return embedding


def save_embedding(tiger_id, embedding):
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    embedding_str = ",".join(map(str, embedding.tolist()))

    cursor.execute(
        "UPDATE tigers SET embedding = %s WHERE tiger_id = %s",
        (embedding_str, tiger_id)
    )

    conn.commit()
    cursor.close()
    conn.close()

    print("✅ Embedding saved for tiger:", tiger_id)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python generate_embedding.py <image_path> <tiger_id>")
        sys.exit(1)

    image_path = sys.argv[1]
    tiger_id = int(sys.argv[2])

    emb = generate_embedding(image_path)
    save_embedding(tiger_id, emb)