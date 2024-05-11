import tensorflow as tf

project_path = ".."
output_directory = project_path + '/output/model'

model_name = 'model_epoch_03'
# Kerasモデルのロード
model = tf.keras.models.load_model(output_directory + '/' + model_name + '.keras')

# TFLiteConverterを使用してモデルを変換
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# 変換されたモデルをファイルとして保存
with open(project_path + '/tflite/' + model_name + '.tflite', 'wb') as f:
    f.write(tflite_model)
