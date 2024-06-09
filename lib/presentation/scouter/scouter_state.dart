import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';

sealed class ScouterState {}

class ScouterCameraState extends ScouterState {
  final CameraController controller;

  ScouterCameraState(this.controller);
}

class ScouterOriginalImageState extends ScouterState {
  final Image originalImage;

  ScouterOriginalImageState(this.originalImage);
  Uint8List get originalImageBytes =>
      Uint8List.fromList(encodePng(originalImage));
}

class ScouterCroppedImageState extends ScouterState {
  final Image croppedImage;
  final Image originalImage;

  ScouterCroppedImageState(this.croppedImage, this.originalImage);

  Uint8List get croppedImageBytes =>
      Uint8List.fromList(encodePng(croppedImage));
}
