import 'package:flutter/material.dart';
import 'package:work_adventure/widgets/base/label/auth_wording.dart';
import 'package:work_adventure/widgets/form/forms/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthWording(
                heading: "Welcome, Brave Adventurer!",
                description:
                    "Embark on your journey to conquer tasks and vanquish procrastination!",
              ),
              LoginForm()
            ],
          ),
        ),
      ),
    );
  }
}
