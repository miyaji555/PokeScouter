import os
import numpy as np
from tensorflow.keras.preprocessing import image
from tensorflow.keras.models import load_model

# 学習済みモデルのロード
model = load_model('object_detection_model.h5')

# テスト画像が格納されているディレクトリのパス
directory_path = '/Users/miyasic/Project/flutter/PokeScouter/python/image/training/output/バンバドロ'

# ディレクトリ内のすべての画像ファイルに対して予測を行う
for filename in os.listdir(directory_path):
    img_path = os.path.join(directory_path, filename)
    img = image.load_img(img_path, target_size=(224, 224))

    # 画像をモデルの入力に適した形式に変換
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    x = x / 255.0

    # 画像のクラスを予測
    predictions = model.predict(x)

    # 最も確率の高いクラスのインデックスを取得し、クラス名を表示
    predicted_class = np.argmax(predictions, axis=1)
    print(f'File: {filename}, Predicted class: {predicted_class}')
