from PIL import Image, ImageDraw, ImageOps
import random
import pandas as pd
import sys
from collections import defaultdict
import math
import json
import os
from tqdm import tqdm

# モジュールがあるディレクトリを追加
sys.path.append('../..')

from util import clear_directory, create_recursive_dir

# 定数を定義
VAL_SPLIT = 0.2  # 検証セットの割合
NUM_REPEATS = 10  # 各ポケモンが登場する回数
NUM_POKEMONS_PER_IMAGE = 6  # 1画像に登場するポケモン数
MAX_ATTEMPTS = 50  # ポケモンの重なりを避けるための最大試行回数

def apply_affine_transformation(image):
    original_width, original_height = image.size
    canvas = Image.new('RGBA', (original_width, original_height), (255, 255, 255, 0))
    canvas.paste(image, (0, 0))

    angle = random.randint(0, 360)
    center_x = canvas.width / 2
    center_y = canvas.height / 2

    scale_x = random.uniform(0.8, 1.2)
    scale_y = random.uniform(0.8, 1.2)
    scaled_width = int(original_width * scale_x)
    scaled_height = int(original_height * scale_y)
    shear = random.uniform(-0.1, 0.1)

    canvas = canvas.rotate(angle, resample=Image.BICUBIC, center=(center_x, center_y))
    canvas = canvas.resize((scaled_width, scaled_height), resample=Image.BICUBIC)
    shear = random.uniform(-0.1, 0.1)
    canvas = canvas.transform((scaled_width, scaled_height), Image.AFFINE, (1, shear, 0, 0, 1, 0), Image.Resampling.BICUBIC)

    return canvas

input_folder_path = "../../../output"
output_image_path_train = "../datasets/pokemon/images/train"
output_image_path_val = "../datasets/pokemon/images/val"
output_label_path_train = "../datasets/pokemon/labels/train"
output_label_path_val = "../datasets/pokemon/labels/val"
output_data_yaml_path = "../output"

clear_directory(output_image_path_train)
clear_directory(output_image_path_val)
clear_directory(output_label_path_train)
clear_directory(output_label_path_val)
clear_directory(output_data_yaml_path)
create_recursive_dir(output_image_path_train)
create_recursive_dir(output_image_path_val)
create_recursive_dir(output_label_path_train)
create_recursive_dir(output_label_path_val)
create_recursive_dir(output_data_yaml_path)

# ラベルを読み込む
spreadsheet_path = '../../学習ラベル.csv'
df = pd.read_csv(spreadsheet_path)

# ファイル名とポケモン名の辞書を作成
pokemon_names = pd.Series(df.poke_name.values, index=df.filename).to_dict()
classes = list(set(pokemon_names.values()))  # クラス名のリストを生成

def is_overlapping(box1, box2):
    return not (box1[2] < box2[0] or box1[0] > box2[2] or box1[3] < box2[1] or box1[1] > box2[3])

def initialize_appearance_matrix(num_pokemon, num_repeats):
    return [[False] * num_repeats for _ in range(num_pokemon)]

def select_pokemon_for_image(appearance_matrix, pokemon_files):
    flat_list = [(i, j) for i in range(len(appearance_matrix)) for j in range(len(appearance_matrix[i])) if not appearance_matrix[i][j]]
    if not flat_list:
        return None
    selected_index = random.choice(flat_list)
    pokemon_index, repeat_index = selected_index
    return pokemon_index, repeat_index

def get_non_overlapping_box(background_size, existing_boxes, icon_size, max_attempts):
    for _ in range(max_attempts):
        x = random.randint(0, background_size[0] - icon_size[0])
        y = random.randint(0, background_size[1] - icon_size[1])
        new_box = (x, y, x + icon_size[0], y + icon_size[1])
        if all(not is_overlapping(new_box, box) for box in existing_boxes):
            return new_box
    return None

def create_image_with_pokemons(background_size, pokemon_files, appearance_matrix, num_pokemons=NUM_POKEMONS_PER_IMAGE, image_index=0, set_type='train'):
    background = Image.new('RGB', background_size, (255, 255, 255))
    annotations = []
    existing_boxes = []

    for _ in range(num_pokemons):
        result = select_pokemon_for_image(appearance_matrix, pokemon_files)
        if result is None:
            break
        pokemon_index, repeat_index = result
        pokemon_file = pokemon_files[pokemon_index]
        pokemon_icon = Image.open(input_folder_path + '/' + pokemon_file)
        pokemon_icon = apply_affine_transformation(pokemon_icon)
        pokemon_name = pokemon_names[pokemon_file]

        icon_size = (pokemon_icon.width, pokemon_icon.height)
        box = get_non_overlapping_box(background_size, existing_boxes, icon_size, MAX_ATTEMPTS)

        if box is not None:
            xmin, ymin, xmax, ymax = box
            background.paste(pokemon_icon, (xmin, ymin), pokemon_icon if pokemon_icon.mode == 'RGBA' else None)
            existing_boxes.append((xmin, ymin, xmax, ymax))
            annotations.append({
                'filename': f'{set_type}_image_{image_index:02d}.png',
                'xmin': xmin,
                'ymin': ymin,
                'xmax': xmax,
                'ymax': ymax,
                'class': pokemon_name
            })
            appearance_matrix[pokemon_index][repeat_index] = True
        else:
            print(f"Could not place {pokemon_name} without overlapping after {MAX_ATTEMPTS} attempts.")

    return background, annotations

num_pokemon = len(pokemon_names)
num_repeats = NUM_REPEATS
appearance_matrix = initialize_appearance_matrix(num_pokemon, num_repeats)
annotations_by_image = defaultdict(list)
num_pokemons_per_image = NUM_POKEMONS_PER_IMAGE

total_images = math.ceil(num_pokemon * num_repeats / num_pokemons_per_image)
num_val_images = int(total_images * VAL_SPLIT)
num_train_images = total_images - num_val_images

print(f'{num_pokemon} 匹のポケモンを {num_repeats} 回ずつ登場させる。1画像につき {num_pokemons_per_image} 匹ずつであるため、{total_images} 枚の画像を生成')
print(f'トレーニングセット: {num_train_images} 枚, 検証セット: {num_val_images} 枚')

i = 0
train_index = 1
val_index = 1
while any(not all(row) for row in appearance_matrix):
    if i < num_train_images:
        set_type = 'train'
        image_index = train_index
        train_index += 1
    else:
        set_type = 'val'
        image_index = val_index
        val_index += 1

    image_filename = f'{set_type}_image_{image_index:02d}.png'
    image, annotations = create_image_with_pokemons((800, 600), df.filename.tolist(), appearance_matrix, num_pokemons_per_image, image_index=image_index, set_type=set_type)

    if set_type == 'train':
        image_path = os.path.join(output_image_path_train, image_filename)
        label_path = os.path.join(output_label_path_train, image_filename.replace('.png', '.txt'))
    else:
        image_path = os.path.join(output_image_path_val, image_filename)
        label_path = os.path.join(output_label_path_val, image_filename.replace('.png', '.txt'))
    
    image.save(image_path)
    with open(label_path, 'w') as f:
        for box in annotations:
            class_id = classes.index(box['class'])
            xmin, ymin, xmax, ymax = box['xmin'], box['ymin'], box['xmax'], box['ymax']
            x_center = (xmin + xmax) / 2.0 / image.width
            y_center = (ymin + ymax) / 2.0 / image.height
            width = (xmax - xmin) / image.width
            height = (ymax - ymin) / image.height
            f.write(f"{class_id} {x_center:.6f} {y_center:.6f} {width:.6f} {height:.6f}\n")

    i += 1

# data.yamlファイルの作成
data_yaml_content = f"""
train: {output_image_path_train}
val: {output_image_path_val}

nc: {len(classes)}
names: {classes}
"""

with open(os.path.join(output_data_yaml_path, 'data.yaml'), 'w') as f:
    f.write(data_yaml_content)

print("data.yamlファイルが生成されました。")
