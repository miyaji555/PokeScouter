import os
from pathlib import Path

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

def create_recursive_dir(path):
    # Path オブジェクトを作成
    directory = Path(path)
    # 親ディレクトリが存在しなければ再帰的に作成
    directory.mkdir(parents=True, exist_ok=True)