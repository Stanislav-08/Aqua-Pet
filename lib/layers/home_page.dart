import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Widget'),
      ),
      body: const Center(
        child: ModelViewer(
          src: 'assets/models/plant.glb',
          alt: "Plant",
          autoRotate: false,
          cameraControls: false,
          cameraOrbit: "0deg 75deg 150%",
        ),
      ),
    );
  }
}