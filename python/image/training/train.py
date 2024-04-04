import pandas as pd
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import Dense, Input,GlobalAveragePooling2D
from tensorflow.keras.models import Model

# CSVファイルを読み込む
labels_df = pd.read_csv('labels.csv')

# 'poke_name' 列から改行文字を削除
labels_df['poke_name'] = labels_df['poke_name'].str.replace('\n', ' ').str.strip()

# 結果を確認
print(labels_df.head())

# 'poke_name'列が文字列型であることを確認（必要であれば変換）
if labels_df['poke_name'].dtype != 'object':
    labels_df['poke_name'] = labels_df['poke_name'].astype(str)

print(labels_df)

# 画像データジェネレータの設定
datagen = ImageDataGenerator(rescale=1./255)

# 画像データジェネレータを使用して画像とラベルを読み込む
train_generator = datagen.flow_from_dataframe(
    dataframe=labels_df,
    directory='../output',  # 画像ファイルのディレクトリを指定
    x_col='filename',  # 画像ファイル名が格納されている列名
    y_col='poke_name',  # ラベルが格納されている列名
    class_mode='categorical',
    target_size=(224, 224),
    batch_size=32
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

# モデルのトレーニング
model.fit(train_generator, epochs=10)

# モデルの保存
model.save('object_detection_model.h5')
