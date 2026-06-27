import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class PlantView extends StatefulWidget {
  const PlantView({
    super.key,
    required this.controller,
    required this.isModelLoaded,
  });

  final Flutter3DController controller;
  final ValueNotifier<bool> isModelLoaded;

  @override
  State<PlantView> createState() => _PlantView();
}

class _PlantView extends State<PlantView> {
  @override
  Widget build(BuildContext context) {
    return Flutter3DViewer(
      controller: widget.controller,
      src: 'assets/models/plant.glb',
      onLoad: (String modelAddress) async {
        await widget.controller.getAvailableAnimations();
        widget.isModelLoaded.value = true; // flip the shared flag
      },
      onError: (String error) {
        debugPrint('Failed to load model: $error');
      },
    );
  }
}