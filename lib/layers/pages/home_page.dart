import 'package:aqua_pet/data/data_structures.dart';
import 'package:aqua_pet/data/models/daily_water_intake.dart';
import 'package:aqua_pet/elements/plant3D.dart';
import 'package:aqua_pet/functions/functions.dart';
import 'package:aqua_pet/services/notification_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.isActive = true});

  final bool isActive;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<Plant3DState> plantKey = GlobalKey();
  final ValueNotifier<bool> isModelLoaded = ValueNotifier(false);

  final dailyIntake = DailyWaterIntake.calculate(
    weightKg: 60,
    activityLevel: 'moderate',
    gender: 'male'
  );

  int currentIntake = 0;

  late final AnimationController _progressController;
  late Animation<double> _progressAnimation;

  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _progressAnimation = AlwaysStoppedAnimation(0.0);
  }

  String get formattedCurrentIntake {
    if (currentIntake < 1000) {
      return '${currentIntake}ml';
    }

    final liters = currentIntake / 1000;

    return liters == liters.roundToDouble()
        ? '${liters.toInt()}L'
        : '${liters.toStringAsFixed(1)}L';
  }

  void _animateProgress(double target) {
    _progressAnimation = Tween<double>(
      begin: _progress,
      end: target,
    ).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    _progress = target;

    _progressController
      ..reset()
      ..forward();
  }

  void _onWaterTap(int water) {
    final plant = plantKey.currentState;

    if (plant == null || !plant.loaded) return;
    if (currentIntake >= dailyIntake) return;

    final remaining = dailyIntake - currentIntake;
    final amountToAdd = water > remaining ? remaining : water;

    setState(() {
      currentIntake += amountToAdd;
    });

    _animateProgress(
      (currentIntake / dailyIntake).clamp(0.0, 1.0),
    );

    plant.playWaterAnimation();
  }

  @override
  void dispose() {
    _progressController.dispose();
    isModelLoaded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;
    const strokeWidth = 16.0;

    final boxSize =
        MediaQuery.of(context).size.width - (screenPadding * 2);

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
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  width: boxSize,
                  height: boxSize,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Plant3D(
                        key: plantKey,
                        isActive: widget.isActive,
                        isModelLoaded: isModelLoaded,
                      ),
                      Container(
                        width: boxSize,
                        height: boxSize,
                        padding: const EdgeInsets.all(strokeWidth / 2),
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return CircularProgressIndicator(
                              value: _progressAnimation.value,
                              color: Colors.yellow,
                              strokeWidth: strokeWidth,
                              backgroundColor: Colors.white,
                              strokeCap: StrokeCap.round,
                            );
                          },
                        ),
                      ),



                      Positioned(
                        top: boxSize - 48,
                        child: Text(
                          '$formattedCurrentIntake/${(dailyIntake / 1000).toStringAsFixed(1)}L',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
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
                              onTap: loaded
                                  ? () => _onWaterTap(entry.value)
                                  : null,
                              child: Container(
                                width: 80,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                  color: loaded
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                child: Text(entry.key),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    ValueListenableBuilder<bool>(
                      valueListenable: isModelLoaded,
                      builder: (context, loaded, _) {
                        return GestureDetector(
                          onTap: loaded
                              ? () => showCustomIntakeModal(
                            context,
                            _onWaterTap,
                          )
                              : null,
                          child: Container(
                            width: boxSize,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(16),
                              color: loaded
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                            child: const Text('Custom'),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    FloatingActionButton(
                      onPressed: () {
                        NotificationService.showNotification(
                          title: 'Water reminder',
                          body: 'Your plant needs water',
                        );
                      },
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