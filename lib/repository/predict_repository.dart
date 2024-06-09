import 'dart:convert';
import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:image/image.dart';
import 'package:poke_scouter/domain/predicted_response.dart';

final predictRepositoryProvider = Provider<PredictRepository>((ref) {
  return PredictRepository();
});

class PredictRepository {
  PredictRepository();

  Future<PredictedResponse> sendImageToApi(Image image) async {
    // 画像をメモリ内のバイトデータにエンコード
    final Uint8List imageData = Uint8List.fromList(encodePng(image));

    // APIに画像を送信
    final request = MultipartRequest(
      'POST',
      Uri.parse('localhost:8000/predict'),
    );
    request.headers.addAll({
      'accept': 'application/json',
      'Content-Type': 'multipart/form-data',
    });
    request.files.add(MultipartFile.fromBytes(
      'image',
      imageData,
      filename: 'cropped_image.png',
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await Response.fromStream(response);
      return PredictedResponse.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load response');
    }
  }
}
