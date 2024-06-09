import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poke_scouter/gen/assets.gen.dart';
import 'package:poke_scouter/presentation/scouter/scouter_state.dart';
import 'package:poke_scouter/providers/scouter_controller_provider.dart';

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
        final controller = state.controller;
        return Scaffold(
          body: ImageView(state: state, controller: controller),
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

class ImageView extends StatelessWidget {
  final ScouterState state;
  final CameraController controller;
  const ImageView({super.key, required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    final originalImageBytes = state.originalImageBytes;
    final croppedImageBytes = state.croppedImageBytes;
    if (croppedImageBytes != null) {
      return _CroppedImageBytes(croppedImageBytes: croppedImageBytes);
    }
    if (originalImageBytes != null) {
      return _OriginalImageView(originalImageBytes: originalImageBytes);
    }
    return _CameraView(controller: controller);
  }
}

class _CameraView extends StatelessWidget {
  final CameraController controller;

  const _CameraView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: CameraPreview(
          controller,
          child: Image.asset(Assets.images.switchFrame.path),
        ));
  }
}

class _OriginalImageView extends StatelessWidget {
  final Uint8List originalImageBytes;

  const _OriginalImageView({super.key, required this.originalImageBytes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.memory(originalImageBytes));
  }
}

class _CroppedImageBytes extends StatelessWidget {
  final Uint8List croppedImageBytes;

  const _CroppedImageBytes({super.key, required this.croppedImageBytes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.memory(croppedImageBytes));
  }
}
