from PIL import Image, ImageDraw, ImageOps
import random
import pandas as pd
import sys
from collections import defaultdict
import math
import json


# モジュールがあるディレクトリを追加
sys.path.append('../..')

from util import clear_directory, create_recursive_dir

def apply_affine_transformation(image):
    # 元の画像サイズ
    original_width, original_height = image.size

    # 歪み前の画像をキャンバスに配置
    canvas = Image.new('RGBA', (original_width, original_height), (255, 255, 255, 0))
    canvas.paste(image, (0, 0))

    angle = random.randint(0, 360)  # 回転角度
    # 回転の中心を画像の中心に設定
    center_x = canvas.width / 2
    center_y = canvas.height / 2

    scale_x = random.uniform(0.8, 1.2)  # X軸の拡大縮小率
    scale_y = random.uniform(0.8, 1.2)  # Y軸の拡大縮小率
    scaled_width = int(original_width * scale_x)
    scaled_height = int(original_height * scale_y)
    shear = random.uniform(-0.1, 0.1)  # 歪みの強さ

    canvas = canvas.rotate(
        angle,
        resample=Image.BICUBIC,
        center=(center_x, center_y)
    )

    # 画像を拡大縮小
    canvas = canvas.resize(
        (scaled_width, scaled_height),
        resample=Image.BICUBIC
    )
    shear = random.uniform(-0.1, 0.1)  # 歪みの強さ
    canvas = canvas.transform(
        (scaled_width, scaled_height),
        Image.AFFINE,
        (1, shear, 0, 0, 1, 0),
        Image.Resampling.BICUBIC
    )

    return canvas

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

def is_overlapping(box1, box2):
    # 各ボックスは(xmin, ymin, xmax, ymax)形式
    return not (box1[2] < box2[0] or box1[0] > box2[2] or box1[3] < box2[1] or box1[1] > box2[3])

def get_non_overlapping_box(background_size, existing_boxes, icon_size, max_attempts=50):
    for _ in range(max_attempts):
        x = random.randint(0, background_size[0] - icon_size[0])
        y = random.randint(0, background_size[1] - icon_size[1])
        new_box = (x, y, x + icon_size[0], y + icon_size[1])
        if all(not is_overlapping(new_box, box) for box in existing_boxes):
            return new_box
    return None  # 適切なボックスが見つからない場合はNoneを返す

def create_image_with_pokemons(background_size, pokemon_files, num_pokemons=6, image_index=0):
    background = Image.new('RGB', background_size, (255, 255, 255))
    annotations = []
    existing_boxes = []

    for _ in range(num_pokemons):
        pokemon_file = random.choice(pokemon_files)
        pokemon_icon = Image.open(input_folder_path + '/' + pokemon_file)
        pokemon_icon = apply_affine_transformation(pokemon_icon)  # 画像に変形を適用
        pokemon_name = pokemon_names[pokemon_file]

        icon_size = (pokemon_icon.width, pokemon_icon.height)
        max_attempts = 50
        box = get_non_overlapping_box(background_size, existing_boxes, icon_size, max_attempts)

        if box is not None:
            xmin, ymin, xmax, ymax = box
            background.paste(pokemon_icon, (xmin, ymin), pokemon_icon if pokemon_icon.mode == 'RGBA' else None)
            existing_boxes.append((xmin, ymin, xmax, ymax))
            annotations.append({
                'filename': f'image_{image_index}.png',
                'xmin': xmin,
                'ymin': ymin,
                'xmax': xmax,
                'ymax': ymax,
                'class': pokemon_name
            })
        else:
            print(f"Could not place {pokemon_name} without overlapping after {max_attempts} attempts.")

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
