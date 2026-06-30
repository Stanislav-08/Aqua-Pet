import 'package:aqua_pet/data/data_structures.dart';
import 'package:aqua_pet/data/models/daily_water_intake.dart';
import 'package:aqua_pet/elements/plant_view.dart';
import 'package:aqua_pet/functions/functions.dart';
import 'package:aqua_pet/services/notification_service.dart';
import 'package:aqua_pet/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.isActive = true});

  /// Whether this page is the one currently shown in the bottom
  /// navigation. Used to release the 3D plant viewer when the user
  /// switches to a different tab.
  final bool isActive;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Flutter3DController controller = Flutter3DController();
  final ValueNotifier<bool> isModelLoaded = ValueNotifier(false);
  int currentIntake = 0;

  @override
  void dispose() {
    isModelLoaded.dispose();
    super.dispose();
  }

  void _onWaterTap(int water) {
    if (!isModelLoaded.value) return;

    setState(() {
      currentIntake += water;
    });

    controller.playAnimation(
      animationName: 'watering_can_action',
      loopCount: 1,
    );

    Future.delayed(const Duration(milliseconds: 2500), () {
      controller.resetAnimation();
      controller.pauseAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;
    const strokeWidth = 16.0;
    int dailyIntake =DailyWaterIntake.calculate(weightKg: 60, activityLevel: 'moderate');
    double boxSize = MediaQuery
        .of(context)
        .size
        .width - (screenPadding * 2);

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
                      onTap: () =>
                          showStreakModal(
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
                          value: (currentIntake/dailyIntake).clamp(0.0, 1.0),
                          color: Colors.yellow,
                          strokeWidth: strokeWidth,
                          backgroundColor: Colors.white,
                          strokeCap: StrokeCap.round,
                        ),
                      ),

                      PlantView(
                        controller: controller,
                        isModelLoaded: isModelLoaded,
                        isActive: widget.isActive,
                      ),

                      Positioned(
                        top: boxSize - 48,
                        child: Text(
                          '${currentIntake}ml/${dailyIntake/1000 - (dailyIntake/1000 % 0.1)}L',
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
                              onTap: loaded ? ()=> _onWaterTap(entry.value) : null,
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

                    ValueListenableBuilder<bool>(
                      valueListenable: isModelLoaded,
                      builder: (context, loaded, _) {
                        return GestureDetector(
                          onTap: loaded
                              ? () => showCustomIntakeModal(context, _onWaterTap)
                              : null,
                          child: Container(
                            width: boxSize,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: loaded ? Colors.white : Colors.grey,
                            ),
                            child: const Text('Custom'),
                          ),
                        );
                      },
                    ),

                    FloatingActionButton(
                      onPressed: () {
                        NotificationService.showNotification(
                          title: "Water reminder",
                          body: "Your plant needs water",
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}