import 'dart:typed_data';

import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:poke_scouter/gen/assets.gen.dart';
import 'package:poke_scouter/presentation/scouter/scouter_state.dart';
import 'package:poke_scouter/providers/scouter_controller_provider.dart';

final imageKey = GlobalKey();
final frameKey = GlobalKey();

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

  const _CameraView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CameraPreview(
          controller,
        ),
        Image.asset(
          Assets.images.switchFrame.path,
          key: frameKey,
        ),
      ],
    );
  }
}

class _OriginalImageView extends StatelessWidget {
  final Uint8List originalImageBytes;

  const _OriginalImageView({required this.originalImageBytes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.memory(
            originalImageBytes,
            key: imageKey,
          ),
          Image.asset(
            Assets.images.switchFrame.path,
            key: frameKey,
          ),
        ],
      ),
    );
  }
}

class _CroppedImageBytes extends StatelessWidget {
  final Uint8List croppedImageBytes;

  const _CroppedImageBytes({required this.croppedImageBytes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Transform.rotate(
            angle: -math.pi / 2, child: Image.memory(croppedImageBytes)));
  }
}

class _FloatingActionButton extends StatelessWidget {
  final ScouterState state;
  final ScouterController controller;

  const _FloatingActionButton({required this.state, required this.controller});

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
                await controller.predictPokemon();
              },
              child: const Icon(Icons.flutter_dash_rounded),
            ),
          ],
        ),
    };
  }
}
