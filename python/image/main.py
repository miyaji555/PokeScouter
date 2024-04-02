from PIL import Image
import os

def extract_character_grid(image_path, save_path, left_margin, top_margins, character_size, horizontal_spacing, vertical_spacing, horizontal_chars):
    try:
        with Image.open(image_path) as img:
            slice_counter = 0

            # 一番外側のループ（縦方向、大きなステップで）
            for margin_index, current_top_margin in top_margins.items():
                # 中間のループ（縦方向、50ステップごと）
                for vert_step in range(50):
                    start_y = current_top_margin + vert_step * (character_size + vertical_spacing)

                    if start_y + character_size > img.height:
                        break  # 画像の高さを超えたら停止

                    # 一番内側のループ（横方向）
                    for horiz_step in range(horizontal_chars):
                        start_x = left_margin + horiz_step * (character_size + horizontal_spacing)
                        bbox = (start_x, start_y, start_x + character_size, start_y + character_size)
                        character_slice = img.crop(bbox)

                        file_path = f'{save_path}/slice_{slice_counter}.png'
                        character_slice.save(file_path)
                        slice_counter += 1

    except IOError:
        print(f"Error opening image file: {image_path}")

# Parameters
left_margin = 42
top_margins = {
    1: 38,
    2: 6989,
    3: 14085,
    4: 21182,
}
character_size = 134
horizontal_spacing = 8
vertical_spacing = 8
horizontal_chars = 7

image_path = 'input.jpg'
save_path = 'output'

# save_path に指定したディレクトリが存在しない場合は作成する
os.makedirs(save_path, exist_ok=True)

extract_character_grid(image_path, save_path, left_margin, top_margins, character_size, horizontal_spacing, vertical_spacing, horizontal_chars)
