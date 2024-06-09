import 'dart:async';

import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:poke_scouter/presentation/scouter/scouter_state.dart';
import 'package:poke_scouter/providers/camera_provider.dart';

final scouterControllerProvider =
    AutoDisposeAsyncNotifierProvider<ScouterController, ScouterState>(() {
  return ScouterController();
});

class ScouterController extends AutoDisposeAsyncNotifier<ScouterState> {
  @override
  FutureOr<ScouterState> build() async {
    return ScouterCameraState(await initializeCamera());
  }

  Future<void> takePicture() async {
    state = await AsyncValue.guard(() async {
      final currentState = state.asData?.value;
      if (currentState is! ScouterCameraState) {
        throw StateError('Unexpected state: $currentState');
      }
      final xfile = await currentState.controller.takePicture();
      final bytes = await xfile.readAsBytes();
      final originalImage = img.decodeImage(bytes);

      // cameraはもう使わないので、disposeする
      currentState.controller.dispose();
      return ScouterOriginalImageState(originalImage!);
    });
  }

  Future<void> cropImage() async {
    state = await AsyncValue.guard(() async {
      final currentState = state.asData?.value;
      if (currentState is! ScouterOriginalImageState) {
        throw StateError('No image available to crop');
      }
      final originalImage = currentState.originalImage;

      // 固定のトリミング範囲を設定
      final int cropX = (originalImage.width * 0.25).toInt();
      final int cropY = (originalImage.height * 0.75).toInt();
      final int cropWidth = (originalImage.width * 0.5).toInt();
      final int cropHeight = (originalImage.height * 0.2).toInt();

      final croppedImage = img.copyCrop(
        originalImage,
        cropX,
        cropY,
        cropWidth,
        cropHeight,
      );

      return ScouterCroppedImageState(croppedImage, originalImage);
    });
  }

  void backStatus() async {
    final currentState = state.asData?.value;
    if (currentState == null) {
      throw StateError('Unexpected state is null');
    }
    final previousState = switch (currentState) {
      ScouterCameraState(:final controller) => ScouterCameraState(controller),
      ScouterOriginalImageState() =>
        ScouterCameraState(await initializeCamera()),
      ScouterCroppedImageState(:final originalImage) =>
        ScouterOriginalImageState(originalImage)
    };

    state = AsyncValue.data(previousState);
  }

  Future<CameraController> initializeCamera() async {
    final camera = ref.read(camerasProvider).first;
    final controller =
        CameraController(camera, ResolutionPreset.high, enableAudio: false);
    await controller.initialize();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  }
}
