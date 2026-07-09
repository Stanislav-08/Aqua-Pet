import 'package:aqua_pet/elements/plant3D.dart';
import 'package:flutter/material.dart';
import 'package:aqua_pet/layers/pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ValueNotifier<bool> isModelLoaded = ValueNotifier(false);
  final GlobalKey<Plant3DState> plantKey = GlobalKey();

  @override
  void dispose() {
    isModelLoaded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const screenPadding = 16.0;
    final boxSize = MediaQuery.of(context).size.width - (screenPadding * 2);

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
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      ),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Colors.blue,
                        ),
                        child: const Icon(Icons.settings),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  width: boxSize,
                  height: boxSize,
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Plant3D(
                    key: plantKey,
                    isActive: true,
                    isModelLoaded: isModelLoaded,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Level',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}