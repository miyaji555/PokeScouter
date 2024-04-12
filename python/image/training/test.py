import os
import numpy as np
from collections import defaultdict
from tensorflow.keras.preprocessing import image
from tensorflow.keras.models import load_model

# 学習済みモデルのロード
model = load_model('object_detection_model.h5')

poke_name = 'ピカチュウ'
# テスト画像が格納されているディレクトリのパス
directory_path = '/Users/miyaji/AndroidStudioProjects/pokenote-v1/python/image/training/output/' + poke_name

# 判定結果をカウントするための辞書
class_counts = defaultdict(int)

# ディレクトリ内のすべての画像ファイルに対して予測を行い、結果を集計する
for filename in os.listdir(directory_path):
    img_path = os.path.join(directory_path, filename)
    img = image.load_img(img_path, target_size=(224, 224))

    # 画像をモデルの入力に適した形式に変換
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    x = x / 255.0

    # 画像のクラスを予測
    predictions = model.predict(x)
    predicted_class = np.argmax(predictions, axis=1)[0]

    # クラスのカウントを更新
    class_counts[predicted_class] += 1


# 各クラスごとの判定回数を出力
for class_index, count in class_counts.items():
    print(f'Class {class_index}: {count} times')
