import 'package:aqua_pet/data/models/user.dart';
import 'package:aqua_pet/elements/bottom_navigation.dart';
import 'package:aqua_pet/services/helpers/user_storage_helper.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _usernameController = TextEditingController();
  final _weightController = TextEditingController();

  String _gender = 'Male';
  String _activityLevel = 'light';

  @override
  void initState() {
    super.initState();

    final user = UserStorageHelper.load();

    _usernameController.text = user.username;
    _gender = user.gender;
    _activityLevel = user.activityLevel;
    _weightController.text =
    user.weight == 0 ? '' : user.weight.toString();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = User(
      username: _usernameController.text.trim(),
      gender: _gender,
      activityLevel: _activityLevel,
      weight: double.tryParse(_weightController.text) ?? 0,
    );

    await UserStorageHelper.save(user);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved'),
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const BottomNavigation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Male',
                  child: Text('Male'),
                ),
                DropdownMenuItem(
                  value: 'Female',
                  child: Text('Female'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _gender = value;
                });
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _activityLevel,
              decoration: const InputDecoration(
                labelText: 'Activity Level',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.directions_run),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'light',
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: 'moderate',
                  child: Text('Moderate'),
                ),
                DropdownMenuItem(
                  value: 'high',
                  child: Text('High'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _activityLevel = value;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}