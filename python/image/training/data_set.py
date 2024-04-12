import os
import numpy as np
import glob
import pandas as pd
import sys
from tensorflow.keras.preprocessing.image import ImageDataGenerator, load_img, img_to_array


def clear_directory(path):
    if os.path.exists(path):
        # ディレクトリ内のファイルとサブディレクトリを削除
        for filename in os.listdir(path):
            file_path = os.path.join(path, filename)
            try:
                if os.path.isfile(file_path) or os.path.islink(file_path):
                    os.unlink(file_path)
                elif os.path.isdir(file_path):
                    shutil.rmtree(file_path)
            except Exception as e:
                print(f'Failed to delete {file_path}. Reason: {e}')


# 生成枚数（１枚あたり）
n_img = 500

project_path = "."

# 生成元画像のパス
input_folder_path = project_path + "/../output"

# ラベルを読み込む
spreadsheet_path = project_path + '/学習ラベル.csv'
df = pd.read_csv(spreadsheet_path)

print(df)



# # 出力先パス
output_folder_path = project_path + "/output"
clear_directory(output_folder_path)
if os.path.isdir(output_folder_path) == False:
  os.mkdir(output_folder_path)

for index, row in df.iterrows():
    file_name = row['filename']
    input_path = os.path.join(input_folder_path, file_name)

    if os.path.exists(input_path):
        poke_name_value = row['poke_name']
        output_path = os.path.join(output_folder_path, poke_name_value)
        print(index, file_name, output_path,input_path)

        if not os.path.isdir(output_path):
            os.mkdir(output_path)

        img = load_img(input_path)
        x = img_to_array(img)
        x = np.expand_dims(x, axis=0)

        datagen = ImageDataGenerator(
            rotation_range=30.0,
            width_shift_range=0.2,  # 最大20%の幅で水平シフト
            height_shift_range=0.2,  # 最大20%の高さで垂直シフト
            shear_range=0.2,  # 画像を最大20%で歪ませる
        )

        # # 生成
        dg = datagen.flow(x, batch_size=1, save_to_dir=output_path, save_prefix= poke_name_value, save_format='png')
        for j in range(n_img):
            batch = next(dg)
    else:
        print(f"{file_name} not found in the input folder")
