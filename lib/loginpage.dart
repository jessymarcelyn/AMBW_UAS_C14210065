import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _pinController = TextEditingController();
  var pinBox = Hive.box('pin');

  @override
  void initState() {
    super.initState();
    if (pinBox.get('pin') == null) {
      Future.delayed(Duration.zero, () => _setPinDialog(context));
    }
  }

  void _setPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final newPinController = TextEditingController();
        return AlertDialog(
          title: const Text('Set PIN'),
          content: TextField(
            controller: newPinController,
            decoration: const InputDecoration(hintText: 'Enter new PIN'),
            obscureText: true,
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newPinController.text.isNotEmpty) {
                  pinBox.put('pin', {'pin': newPinController.text});
                  Navigator.pop(context);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 217, 163, 70)),
              ),
              child: const Text(
                'Set PIN',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _login() {
    final storedPin = pinBox.get('pin');
    if (_pinController.text == storedPin?['pin']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Incorrect PIN')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 50.0), 
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Notes Application',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 300,
                    child: TextField(
                      controller: _pinController,
                      decoration: const InputDecoration(hintText: 'Enter PIN'),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _login,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 217, 163, 70)),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
