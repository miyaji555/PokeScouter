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
        return Scaffold(
          body: ImageView(
            state: state,
          ),
          floatingActionButton: _FloatingActionButton(
              state: state, controller: scouterController),
        );
      },
    );
  }
}

class ImageView extends StatelessWidget {
  final ScouterState state;
  const ImageView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ScouterCameraState(:final controller) =>
        _CameraView(controller: controller),
      ScouterOriginalImageState(:final originalImageBytes) =>
        _OriginalImageView(originalImageBytes: originalImageBytes),
      ScouterCroppedImageState(:final croppedImageBytes) =>
        _CroppedImageBytes(croppedImageBytes: croppedImageBytes),
    };
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

class _FloatingActionButton extends StatelessWidget {
  final ScouterState state;
  final ScouterController controller;

  const _FloatingActionButton(
      {super.key, required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ScouterCameraState() => FloatingActionButton(
          onPressed: () async {
            await controller.takePicture();
          },
          child: const Icon(Icons.camera_alt)),
      ScouterOriginalImageState() => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                controller.backStatus();
              },
              child: const Icon(Icons.back_hand),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              onPressed: () async {
                await controller.cropImage();
              },
              child: const Icon(Icons.crop),
            ),
          ],
        ),
      ScouterCroppedImageState() => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                controller.backStatus();
              },
              child: const Icon(Icons.back_hand),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              onPressed: () async {
                await controller.cropImage();
              },
              child: const Icon(Icons.crop),
            ),
          ],
        ),
    };
  }
}
