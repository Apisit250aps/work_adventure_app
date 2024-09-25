import 'package:flutter/material.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';
import 'package:work_adventure/widgets/form/inputs/password_input_label.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Login",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Lorem ipsum",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                InputLabel(
                  label: 'Username',
                  // hintText: 'Enter text here',
                  controller: TextEditingController(),
                ),
                PasswordInputLabel(
                  label: 'Password',
                  // hintText: 'Enter your password',
                  controller: TextEditingController(),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
