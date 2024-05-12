import json
from PIL import Image, ImageDraw
import sys

# モジュールがあるディレクトリを追加
sys.path.append('../..')

from util import clear_directory, create_recursive_dir

def draw_bounding_boxes(image_path, annotations, output_path):
    # 画像を読み込む
    image = Image.open(image_path)
    draw = ImageDraw.Draw(image)

    # アノテーションごとにバウンディングボックスを描画
    for annotation in annotations:
        xmin = annotation['xmin']
        ymin = annotation['ymin']
        xmax = annotation['xmax']
        ymax = annotation['ymax']
        draw.rectangle(((xmin, ymin), (xmax, ymax)), outline="red", width=3)

    # 画像を保存または表示
    image.save(output_path)

# アノテーションファイルの読み込み
with open('../output/annotations.json', 'r') as file:
    annotations_by_image = json.load(file)


output_annotation_path = "../output"

checkd_image_path = "../output/checked"
clear_directory(checkd_image_path)
create_recursive_dir(checkd_image_path)

# 各画像に対してバウンディングボックスを描画
for image_filename, annotations in annotations_by_image.items():
    image_path = f'../output/image/{image_filename}'
    output_path = f'../output/checked/{image_filename}'
    draw_bounding_boxes(image_path, annotations, output_path)
