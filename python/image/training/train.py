import pandas as pd
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import Dense, Input,GlobalAveragePooling2D
from tensorflow.keras.models import Model
from tensorflow.keras.callbacks import ModelCheckpoint, CSVLogger  # CSVLoggerをインポート


project_path = "."

# 生成元画像のパス
input_folder_path = project_path + "/../output"

# 画像データジェネレータの設定
train_datagen = ImageDataGenerator(
    rescale=1./255,  # 画像の正規化のみ行う
    validation_split=0.2  # 20%を検証用に分割
)

# トレーニングデータジェネレータ
train_generator = train_datagen.flow_from_directory(
    directory='output',  # 画像ファイルのディレクトリを指定
    target_size=(224, 224),
    batch_size=32,
    class_mode='categorical',
    subset='training'
)

# クラスとラベルの対応表を取得
class_indices = train_generator.class_indices

# テキストファイルに出力
with open('class_labels.txt', 'w') as file:
    for class_name, index in class_indices.items():
        file.write(f'{class_name}: {index}\n')


# 検証データジェネレータ
validation_generator = train_datagen.flow_from_directory(
    directory='output',  # 画像ファイルのディレクトリを指定
    target_size=(224, 224),
    batch_size=32,
    class_mode='categorical',
    subset='validation'
)
# ベースとなるモデルをロード
base_model = MobileNetV2(weights='imagenet', include_top=False, input_tensor=Input(shape=(224, 224, 3)))

# ベースモデルの出力に全結合層を追加する前にグローバル平均プーリング層を追加
x = base_model.output
x = GlobalAveragePooling2D()(x)  # 2D特徴マップを1Dベクトルに変換
x = Dense(1024, activation='relu')(x)
predictions = Dense(len(train_generator.class_indices), activation='softmax')(x)

# モデルを定義
model = Model(inputs=base_model.input, outputs=predictions)

# モデルのコンパイル
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# CSVLoggerの設定
csv_logger = CSVLogger('training_log.csv', append=True)

# モデルチェックポイントの設定
model_checkpoint = ModelCheckpoint(
    'best_model.keras',
    save_best_only=True,
    monitor='val_accuracy',
    mode='max'
)

# モデルのトレーニング
model.fit(
    train_generator,
    epochs=3,
    validation_data=validation_generator,
    callbacks=[csv_logger, model_checkpoint]
)
# モデルの保存
model.save('object_detection_model.h5')

