import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'loginpage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var pinBox = Hive.box('pin');
  var noteBox = Hive.box('notes');
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();

  void _changePin() {
    final storedPin = pinBox.get('pin');
    if (_currentPinController.text == storedPin?['pin']) {
      pinBox.put('pin', {'pin': _newPinController.text});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN changed successfully')),
      );
      _currentPinController.clear();
      _newPinController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current PIN is incorrect')),
      );
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _restartApp() async {
    await pinBox.clear();
    await noteBox.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _restartApp,
            tooltip: 'Restart App',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    children: [
                      const Text(
                        'Edit PIN',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 300,
                        child: TextField(
                          controller: _currentPinController,
                          decoration: const InputDecoration(
                            hintText: 'Enter current PIN',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12.0),
                            border:
                                UnderlineInputBorder(), // Ensure bottom border
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 300,
                        child: TextField(
                          controller: _newPinController,
                          decoration: const InputDecoration(
                            hintText: 'Enter new PIN',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12.0),
                            border: UnderlineInputBorder(),
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _changePin,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 217, 163, 70)),
                        ),
                        child: const Text(
                          'Change PIN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
