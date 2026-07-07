import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class Plant3D extends StatefulWidget {
  const Plant3D({
    super.key,
    required this.isActive,
    required this.isModelLoaded,
  });

  final bool isActive;
  final ValueNotifier<bool> isModelLoaded;

  @override
  State<Plant3D> createState() => Plant3DState();
}

class Plant3DState extends State<Plant3D> {
  final GlobalKey _boundaryKey = GlobalKey();
  final Flutter3DController _controller = Flutter3DController();

  ui.Image? _snapshot;
  bool _showSnapshot = false;

  Timer? _revealTimer;
  Timer? _refreshTimer;

  static const _transitionWindow = Duration(milliseconds: 350);

  bool get loaded => widget.isModelLoaded.value;

  void playWaterAnimation() {
    // NOT SUPPORTED in this package version
    // remove or replace with model animation trigger if available
  }

  @override
  void initState() {
    super.initState();

    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (widget.isActive && loaded && !_showSnapshot) {
        _captureSnapshot();
      }
    });
  }

  @override
  void didUpdateWidget(covariant Plant3D oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isActive == widget.isActive) return;

    _captureSnapshot();
    setState(() => _showSnapshot = true);

    _revealTimer?.cancel();
    _revealTimer = Timer(_transitionWindow, () {
      if (mounted) setState(() => _showSnapshot = false);
    });
  }

  Future<void> _captureSnapshot() async {
    try {
      final renderObject = _boundaryKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) return;
      if (renderObject.debugNeedsPaint) return;

      final pixelRatio = MediaQuery.devicePixelRatioOf(context);
      final image = await renderObject.toImage(pixelRatio: pixelRatio);

      final old = _snapshot;

      if (mounted) {
        setState(() => _snapshot = image);
      } else {
        image.dispose();
      }

      old?.dispose();
    } catch (_) {}
  }
  @override
  void dispose() {
    _revealTimer?.cancel();
    _refreshTimer?.cancel();
    _snapshot?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;
    final useSnapshot = _showSnapshot && snapshot != null;

    return Stack(
      fit: StackFit.expand,
      children: [
        Offstage(
          offstage: useSnapshot,
          child: RepaintBoundary(
            key: _boundaryKey,
            child: Flutter3DViewer(
              src: 'assets/models/cactus.glb',
              controller: _controller,
              enableTouch: false,
              onLoad: (String modelAddress) {
                _controller.setCameraOrbit(20, 20, 5); // <-- set your desired starting orbit here
              },
            ),
          ),
        ),

        if (useSnapshot)
          RawImage(
            image: snapshot,
            fit: BoxFit.contain,
          ),
      ],
    );
  }
}