import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poke_scouter/gen/assets.gen.dart';
import 'package:poke_scouter/presentation/scouter/scouter_controller.dart';

class ScouterPage extends ConsumerWidget {
  const ScouterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scouterControllerProvider);
    final scouterController = ref.read(scouterControllerProvider.notifier);

    return state.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Text('Error: $error'),
      data: (state) {
        final originalImageBytes = state.originalImageBytes;
        if (originalImageBytes != null) {
          return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.memory(originalImageBytes));
        }

        final controller = state.controller;
        return Scaffold(
          body: SizedBox(
              width: double.infinity,
              child: CameraPreview(
                controller,
                child: Image.asset(Assets.images.switchFrame.path),
              )),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              scouterController.takePicture();
            },
            child: const Icon(Icons.camera),
          ),
        );
      },
    );
  }
}
