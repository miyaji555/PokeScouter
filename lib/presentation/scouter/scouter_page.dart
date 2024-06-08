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

    return state.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Text('Error: $error'),
      data: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                  width: double.infinity, child: CameraPreview(controller!)),
              Image.asset(Assets.images.switchFrame.path),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (controller.value.isInitialized) {
                await controller.takePicture();
              }
            },
            child: Icon(Icons.camera),
          ),
        );
      },
    );
  }
}
