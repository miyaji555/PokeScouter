from PIL import Image, ImageDraw
import random
import pandas as pd
import json
import sys
from collections import defaultdict

# モジュールがあるディレクトリを追加
sys.path.append('../..')

from util import clear_directory, create_recursive_dir

input_folder_path = "../../../output"
output_image_path = "../output/image"
output_annotation_path = "../output"

clear_directory(output_image_path)
create_recursive_dir(output_image_path)
create_recursive_dir(output_annotation_path)

# ラベルを読み込む
spreadsheet_path = '../../学習ラベル.csv'
df = pd.read_csv(spreadsheet_path)

# ファイル名とポケモン名の辞書を作成
pokemon_names = pd.Series(df.poke_name.values, index=df.filename).to_dict()

def create_image_with_pokemons(background_size, pokemon_files, num_pokemons=6, image_index=0):
    # 白い背景画像の作成
    background = Image.new('RGB', background_size, (255, 255, 255))
    annotations = []

    for _ in range(num_pokemons):
        # ランダムにポケモンを選択
        pokemon_file = random.choice(pokemon_files)
        pokemon_icon = Image.open(input_folder_path + '/' + pokemon_file)
        pokemon_name = pokemon_names[pokemon_file]  # ポケモンの名前を取得

        # ポケモンのアルファチャンネルをマスクとして使用
        if pokemon_icon.mode == 'RGBA':
            mask = pokemon_icon.split()[3]
        else:
            mask = None

        # ポケモンをランダムな位置に配置
        x = random.randint(0, background.width - pokemon_icon.width)
        y = random.randint(0, background.height - pokemon_icon.height)
        background.paste(pokemon_icon, (x, y), mask)

        # アノテーションデータの記録
        annotations.append({
            'xmin': x,
            'ymin': y,
            'xmax': x + pokemon_icon.width,
            'ymax': y + pokemon_icon.height,
            'class': pokemon_name  # クラス名を追加
        })

    return background, annotations

# 画像とアノテーションの生成
annotations_by_image = defaultdict(list)
for i in range(3):  # 3枚の画像を生成
    image, annotations = create_image_with_pokemons((800, 600), df.filename.tolist(), num_pokemons=6, image_index=i)
    image_filename = f'image_{i}.png'
    image.save(f'{output_image_path}/{image_filename}')
    for annotation in annotations:
        annotation['filename'] = image_filename
        annotations_by_image[image_filename].append(annotation)

# JSON形式で全アノテーションを保存
with open(f'{output_annotation_path}/annotations.json', 'w') as f:
    json.dump(annotations_by_image, f, indent=4, ensure_ascii=False)
