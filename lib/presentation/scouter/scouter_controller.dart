import 'dart:async';

import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poke_scouter/providers/camera_provider.dart';

final scouterControllerProvider =
    AsyncNotifierProvider<ScouterController, CameraController?>(() {
  return ScouterController();
});

class ScouterController extends AsyncNotifier<CameraController?> {
  @override
  FutureOr<CameraController?> build() async {
    final camera = ref.read(camerasProvider).first;
    final controller = CameraController(camera, ResolutionPreset.high);
    await controller.initialize();
    return controller;
  }
}
