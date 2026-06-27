import 'package:aqua_pet/data/data_structures.dart';
import 'package:aqua_pet/elements/plant_view.dart';
import 'package:aqua_pet/functions/functions.dart';
import 'package:aqua_pet/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Flutter3DController controller = Flutter3DController();
  final ValueNotifier<bool> isModelLoaded = ValueNotifier(false);

  @override
  void dispose() {
    isModelLoaded.dispose();
    super.dispose();
  }

  void _onWaterTap() {
    if (!isModelLoaded.value) return; // ignore taps before model is ready

    controller.playAnimation(animationName: 'watering_can_action', loopCount: 1);
    Future.delayed(const Duration(milliseconds: 2500), () {
      controller.resetAnimation();
      controller.pauseAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;
    const strokeWidth = 16.0;

    double boxSize = MediaQuery.of(context).size.width - (screenPadding * 2);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(screenPadding),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => showStreakModal(
                        context,
                        currentStreak: 3,
                        bestStreak: 10,
                      ),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.red,
                        ),
                        child: const Icon(Icons.local_fire_department_rounded),
                      ),
                    ),
                  ],
                ),

                Container(
                  width: boxSize,
                  height: boxSize,
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: boxSize,
                        height: boxSize,
                        padding: const EdgeInsets.all(strokeWidth / 2),
                        child: CircularProgressIndicator(
                          value: 0.75,
                          color: Colors.yellow,
                          strokeWidth: strokeWidth,
                          backgroundColor: Colors.white,
                          strokeCap: StrokeCap.round,
                        ),
                      ),

                      PlantView(
                        controller: controller,
                        isModelLoaded: isModelLoaded,
                      ),

                      Positioned(
                        top: boxSize - 48,
                        child: const Text(
                          '500ml/5L',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: intakes.entries.map((entry) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: isModelLoaded,
                          builder: (context, loaded, _) {
                            return GestureDetector(
                              onTap: loaded ? _onWaterTap : null,
                              child: Container(
                                width: 80,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: loaded ? Colors.white : Colors.grey,
                                ),
                                child: Text('${entry.key}'),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    FloatingActionButton(onPressed: ()=> NotificationService.showNotification(
                      title: "Water reminder",
                      body: "Your plant needs water",
                    ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}