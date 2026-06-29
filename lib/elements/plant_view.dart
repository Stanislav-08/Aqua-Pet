import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class PlantView extends StatefulWidget {
  const PlantView({
    super.key,
    required this.controller,
    required this.isModelLoaded,
    required this.isActive,
  });

  final Flutter3DController controller;
  final ValueNotifier<bool> isModelLoaded;

  /// Whether the Home tab is the one currently visible on screen.
  /// The WebView-backed viewer stays mounted at all times - tearing
  /// it down and recreating it on every tab switch is far more
  /// expensive (a full WebView + local server round-trip + model
  /// reload). Instead, whenever this flips we briefly cover the live
  /// view with a frozen screenshot for the duration of the tab-switch
  /// animation, so there's no hybrid-composition platform view in
  /// the frame competing with that animation for the platform thread.
  final bool isActive;

  @override
  State<PlantView> createState() => _PlantView();
}

class _PlantView extends State<PlantView> {
  final GlobalKey _boundaryKey = GlobalKey();

  // The last good screenshot of the live viewer. Shown in place of
  // the live WebView while the tab-switch animation is running.
  ui.Image? _snapshot;
  bool _showSnapshot = false;

  // Slightly longer than the bottom bar's own transition duration,
  // so the live view only reappears once the animation has settled.
  static const _transitionWindow = Duration(milliseconds: 350);

  Timer? _revealTimer;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Keep the snapshot reasonably fresh while idle on the Home tab,
    // in case the model is mid-animation (e.g. watering) right when
    // the user switches away.
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (widget.isActive && !_showSnapshot) _captureSnapshot();
    });
  }

  @override
  void didUpdateWidget(covariant PlantView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isActive == widget.isActive) return;

    if (!widget.isActive) {
      widget.controller.pauseAnimation();
    }

    // Grab the freshest possible frame, then immediately cover the
    // live viewer with it for the duration of the transition.
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

      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final image = await renderObject.toImage(pixelRatio: pixelRatio);

      final old = _snapshot;
      if (mounted) {
        setState(() => _snapshot = image);
      } else {
        image.dispose();
      }
      old?.dispose();
    } catch (_) {
      // Best-effort optimization - if a capture ever fails, we just
      // fall through to showing the live viewer as normal.
    }
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
        // The live, WebView-backed 3D viewer. Always kept mounted.
        // While useSnapshot is true it's Offstage - still alive, just
        // excluded from this frame's compositing, so it can't compete
        // with the tab-switch animation for the platform thread.
        Offstage(
          offstage: useSnapshot,
          child: RepaintBoundary(
            key: _boundaryKey,
            child: Flutter3DViewer(
              controller: widget.controller,
              src: 'assets/models/plant.glb',
              enableTouch: false,
              onLoad: (String modelAddress) async {
                if (!widget.isModelLoaded.value) {
                  await widget.controller.getAvailableAnimations();
                  widget.isModelLoaded.value = true;
                }
                // First good frame is ready to snapshot.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _captureSnapshot();
                });
              },
              onError: (String error) {
                debugPrint('Failed to load model: $error');
              },
            ),
          ),
        ),

        if (useSnapshot) RawImage(image: snapshot, fit: BoxFit.contain),
      ],
    );
  }
}