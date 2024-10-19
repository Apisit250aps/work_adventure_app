import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/dialog/message_dialog.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final UserController userController = Get.find<UserController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  void submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final status = await userController.register(
          emailController.text,
          usernameController.text,
          passwordController.text,
        );
        if (status == 201) {
          Get.toNamed('/login');
        } else if (status == 409) {
          Get.dialog(const MessageDialog(
            title: "Error!",
            message: "Username already exists!",
            icon: "error",
            btnText: "Close",
          ));
        }
      } catch (e) {
        Get.dialog(const MessageDialog(
          title: "Error!",
          message: "Server Error",
          icon: "error",
          btnText: "Close",
        ));
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
            RegisterFormGroup(
              emailController: emailController,
              usernameController: usernameController,
              passwordController: passwordController,
            ),
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
                          "ลงทะเบียนใช้งาน",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
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

class RegisterFormGroup extends StatelessWidget {
  final TextEditingController? usernameController;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  const RegisterFormGroup(
      {super.key,
      this.usernameController,
      this.emailController,
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
          EmailTextField(
            controller: emailController,
          ),
          PasswordTextField(
            controller: passwordController,
          ),
        ],
      ),
    );
  }
}
