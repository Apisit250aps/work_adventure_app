import 'package:flutter/material.dart';
import 'package:work_adventure/widgets/base/label/auth_wording.dart';
import 'package:work_adventure/widgets/form/forms/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                heading: "Create Your Hero",
                description: "Forge your legend in the realm of productivity!",
              ),
              RegisterForm()
            ],
          ),
        ),
      ),
    );
  }
}
