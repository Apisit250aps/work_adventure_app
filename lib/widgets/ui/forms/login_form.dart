import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/main.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/dialog/message_dialog.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final UserController userController = Get.find<UserController>();
  final CharacterController characterController =
      Get.find<CharacterController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final status = await userController.login(
          usernameController.text,
          passwordController.text,
        );
        if (status == 200) {
          characterController.loadCharacters();
          Get.offAll(() => const AuthWrapper());
        } else if (status == 401) {
          Get.dialog(const MessageDialog(
            title: "Error!",
            message: "Invalid username or password!",
            icon: "error",
            btnText: "Close",
          ));
        }
      } catch (e) {
        Get.snackbar(
          'Login Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
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
            const SizedBox(height: 20),
            GradientButton(
              gradientColors: [
                primaryColor,
                secondaryColor,
              ],
              onPressed: submit,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "เข้าสู่ระบบ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        // SizedBox(width: 8),
                        // Icon(
                        //   Boxicons.bx_chevron_right,
                        //   color: Colors.white,
                        // )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginFormGroup extends StatelessWidget {
  final TextEditingController? usernameController;
  final TextEditingController? passwordController;
  const LoginFormGroup(
      {super.key, this.usernameController, this.passwordController});
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
