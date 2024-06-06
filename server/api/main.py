from fastapi import FastAPI, File, UploadFile
import torch
from PIL import Image
import io
import pandas as pd
from typing import List

app = FastAPI()

label_path = 'model/label-top150.csv'
# CSVファイルの読み込み
df = pd.read_csv(label_path)  # CSVファイル名を指定
poke_dict = dict(zip(df['poke_name'], df['number']))

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
    
    # クラス名をポケモンナンバーに変換
    class_numbers = [poke_dict.get(name, 'Unknown') for name in class_names]

    # 結果を整理して返す
    detections = [{'class_name': name, 'number': number} for name, number in zip(class_names, class_numbers) if number != 'Unknown' and number < 10000]
    
    response = {
        'pokemon': detections
    }
    
    return response