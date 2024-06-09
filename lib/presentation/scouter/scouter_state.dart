import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image/image.dart';

part 'scouter_state.freezed.dart';

@freezed
class ScouterState with _$ScouterState {
  const factory ScouterState({
    required CameraController controller,
    Image? originalImage,
    Image? croppedImage,
  }) = _ScouterState;
}

extension ScouterStateX on ScouterState {
  Uint8List? get originalImageBytes {
    final image = originalImage;
    if (image == null) {
      return null;
    }
    return Uint8List.fromList(encodePng(image));
  }

  Uint8List? get croppedImageBytes {
    final image = croppedImage;
    if (image == null) {
      return null;
    }
    return Uint8List.fromList(encodePng(image));
  }
}
