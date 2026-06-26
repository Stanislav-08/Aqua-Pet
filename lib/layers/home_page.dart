import 'package:aqua_pet/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    double screenPadding = 16;
    const strokeWidth = 16.0;
    double boxSize = MediaQuery
        .of(context)
        .size
        .width - (screenPadding * 2);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenPadding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                        child: Icon(Icons.local_fire_department_rounded),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: boxSize,
                  height: boxSize,
                  decoration: BoxDecoration(
                    color: Colors.blue,),
                  child:
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(strokeWidth / 2),
                        width: double.infinity,
                        height: double.infinity,
                        child: CircularProgressIndicator(
                          value: 0.75,
                          color: Colors.yellow,
                          strokeWidth: strokeWidth,
                          backgroundColor: Colors.white,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      SizedBox(
                        width: boxSize - 80,
                        height: boxSize - 80,
                        child: ModelViewer(
                          src: 'assets/models/plant.glb',
                          alt: 'Plant',
                          autoRotate: false,
                          cameraControls: false,
                          cameraOrbit: '0deg 75deg 100%',
                        ),
                      ),
                      Positioned(
                        top: boxSize-48,
                        child:
                          Text(
                            '500ml/5L',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}