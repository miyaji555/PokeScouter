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

def create_image_with_pokemons(background_size, pokemon_files, appearance_matrix, num_pokemons=6, image_index=0):
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
            appearance_matrix[pokemon_index][repeat_index] = True
        else:
            print(f"Could not place {pokemon_name} without overlapping after {max_attempts} attempts.")

    return background, annotations

num_pokemon = len(pokemon_names)
num_repeats = 10
appearance_matrix = initialize_appearance_matrix(num_pokemon, num_repeats)
annotations_by_image = defaultdict(list)
num_pokemons_per_image = 6

print(f'{num_pokemon} 匹のポケモンを {num_repeats} 回ずつ登場させる。1画像につき {num_pokemons_per_image} 匹ずつであるため、{math.ceil(num_pokemon * num_repeats / num_pokemons_per_image)} 枚の画像を生成')

i = 0
while any(not all(row) for row in appearance_matrix):
    image_filename = f'image_{i}.png'
    image, annotations = create_image_with_pokemons((800, 600), df.filename.tolist(), appearance_matrix, num_pokemons_per_image, image_index=i)
    image.save(f'{output_image_path}/{image_filename}')
    for annotation in annotations:
        annotation['filename'] = image_filename
        annotations_by_image[image_filename].append(annotation)
    i += 1

# YOLO形式に変換
os.makedirs(f'{output_annotation_path}/labels', exist_ok=True)

for image_file, boxes in tqdm(annotations_by_image.items()):
    label_file = os.path.join(output_annotation_path, 'labels', image_file.replace('.png', '.txt'))
    
    with open(label_file, 'w') as f:
        for box in boxes:
            class_id = classes.index(box['class'])
            xmin, ymin, xmax, ymax = box['xmin'], box['ymin'], box['xmax'], box['ymax']
            
            img_path = os.path.join(output_image_path, image_file)
            img = Image.open(img_path)
            img_width, img_height = img.size
            
            x_center = (xmin + xmax) / 2.0 / img_width
            y_center = (ymin + ymax) / 2.0 / img_height
            width = (xmax - xmin) / img_width
            height = (ymax - ymin) / img_height
            
            f.write(f"{class_id} {x_center:.6f} {y_center:.6f} {width:.6f} {height:.6f}\n")
