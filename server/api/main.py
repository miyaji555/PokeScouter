from fastapi import FastAPI, File, UploadFile
import torch
from PIL import Image
import io
from typing import List

app = FastAPI()

# トレーニング済みモデルのロード
model = torch.hub.load('ultralytics/yolov5', 'custom', path='model/best.pt')

@app.get("/hello")
async def hello():
    return {"message": "hello signals"}

@app.post("/predict")
async def predict(image: UploadFile = File(...)):
    img_bytes = await image.read()
    img = Image.open(io.BytesIO(img_bytes))

    # 推論
    results = model(img)

    # 検出されたクラスとIDのリストを取得
    detected_classes = results.xyxyn[0][:, -1].cpu().numpy().astype(int).tolist()
    class_names = [model.names[i] for i in detected_classes]
    
    # 結果を整理して返す
    detections = [{'class_name': class_names[i], 'id': detected_classes[i]} for i in range(len(class_names))]
    
    response = {
        'pokemon': detections
    }
    
    return response