import 'dart:async';

import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart';
import 'package:poke_scouter/presentation/scouter/scouter_page.dart';
import 'package:poke_scouter/presentation/scouter/scouter_state.dart';
import 'package:poke_scouter/providers/camera_provider.dart';
import 'package:poke_scouter/repository/predict_repository.dart';
import 'package:poke_scouter/util/logger.dart';

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
      final cropRange = _calcCropRange(originalImage);
      final croppedImage = img.copyCrop(
        currentState.originalImage,
        cropRange.cropX,
        cropRange.cropY,
        cropRange.cropWidth,
        cropRange.cropHeight,
      );

      return ScouterCroppedImageState(croppedImage, originalImage);
    });
  }

  ({int cropX, int cropY, int cropWidth, int cropHeight}) _calcCropRange(
      Image originalImage) {
    final originalImageHeight = originalImage.height;
    final originalImageWidth = originalImage.width;
    // frame画像のサイズとトリミングエリアの位置とサイズ
    const frameHeight = 1920;
    const frameWidth = 1080;
    const subFrameX = 358;
    const subFrameY = 1058;
    const subFrameHeight = 282;
    const subFrameWidth = 405;

    final imageSize = imageKey.currentContext?.size;
    if (imageSize == null) {
      throw StateError('Unexpected imageSize is null');
    }
    final frameSize = frameKey.currentContext?.size;
    if (frameSize == null) {
      throw StateError('Unexpected frameSize is null');
    }

    final imageScaleY = originalImageHeight / imageSize.height;
    final imageScaleX = originalImageWidth / imageSize.width;
    final frameScaleX = frameHeight / frameSize.height;
    final frameScaleY = frameWidth / frameSize.width;

    // ディスプレイ上の見かけのトリミングエリアの位置とサイズ
    final displayedCropY =
        ((originalImageHeight / imageScaleY - frameHeight / frameScaleY) / 2 +
            subFrameY / frameScaleY);
    final displayedCropX =
        ((originalImageWidth / imageScaleX - frameWidth / frameScaleX) / 2 +
            subFrameX / frameScaleX);
    final displayedCropWidth = subFrameWidth / frameScaleX;
    final displayedCropHeight = subFrameHeight / frameScaleY;

    // 実際の画像上のトリミングエリアの位置とサイズ
    final cropY = displayedCropY * imageScaleY;
    final cropX = displayedCropX * imageScaleX;
    final cropWidth = displayedCropWidth * imageScaleX;
    final cropHeight = displayedCropHeight * imageScaleY;

    return (
      cropX: cropX.round(),
      cropY: cropY.round(),
      cropWidth: cropWidth.round(),
      cropHeight: cropHeight.round(),
    );
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
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    await controller.initialize();
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  }

  Future<void> predictPokemon() async {
    final currentState = state.asData?.value;
    if (currentState is! ScouterCroppedImageState) {
      throw StateError('No image available to predict');
    }
    final result = await ref
        .read(predictRepositoryProvider)
        .sendImageToApi(currentState.croppedImage);
    logger.d(result);
  }
}
