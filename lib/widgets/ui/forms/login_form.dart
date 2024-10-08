import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          LoginFormGroup(
     
            usernameController: usernameController,
            passwordController: passwordController,
          ),
          GradientButton(
            gradientColors: [
              primaryColor,
              secondaryColor,
            ],
            onPressed: () {
               
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Icon(
                  Boxicons.bx_chevron_right,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginFormGroup extends StatelessWidget {
  final TextEditingController? usernameController;
  final TextEditingController? passwordController;
  const LoginFormGroup(
      {super.key,
      this.usernameController,
      this.passwordController});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 10), // corresponds to 0px 10px
            blurRadius: 50, // corresponds to 50px
          )
        ],
      ),
      child: Column(
        children: [
          UsernameTextField(
            controller: usernameController,
          ),
          PasswordTextField(
            controller: passwordController,
          ),
        ],
      ),
    );
  }
}