import 'dart:async';

import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poke_scouter/providers/camera_provider.dart';

final scouterControllerProvider =
    AutoDisposeAsyncNotifierProvider<ScouterController, CameraController?>(() {
  return ScouterController();
});

class ScouterController extends AutoDisposeAsyncNotifier<CameraController?> {
  @override
  FutureOr<CameraController?> build() async {
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
