import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/widgets/ui/forms/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/icons/Logo.png',
                  width: 150,
                ),
              ),
              const RegisterForm(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "มีบัญชีอยู่แล้ว ? ",
                    style: TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    child: Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: linkTextColor,
                        // fontStyle: FontStyle.italic,
                      ),
                    ),
                    onTap: () {
                      Get.offAllNamed('/login');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
