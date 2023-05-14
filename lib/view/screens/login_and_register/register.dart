import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_doctor/utils/functions.dart';

import '../../../controller/auth_controller.dart';
import '../../widgets/ui.dart';
import 'login.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (controller) {
            return Form(
              key: controller.registerFormKey,
              child: Material(
                color: Colors.white,
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    Image.asset('assets/images/login_image.jpg'),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) =>
                          controller.nameFieldValidator(value),
                      onSaved: (name) => controller.name = name!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) =>
                          controller.emailFieldValidator(value),
                      onSaved: (email) => controller.email = email!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: controller.passToggle ? true : false,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () => controller.toggleHidePassword(false),
                          child: controller.passToggle
                              ? const Icon(CupertinoIcons.eye_slash_fill)
                              : const Icon(CupertinoIcons.eye_fill),
                        ),
                      ),
                      validator: (value) =>
                          controller.passwordFieldValidator(value),
                      onSaved: (password) => controller.password = password!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: controller.rePassToggle ? true : false,
                      decoration: InputDecoration(
                        labelText: "Re-Password",
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () => controller.toggleHidePassword(true),
                          child: controller.rePassToggle
                              ? const Icon(CupertinoIcons.eye_slash_fill)
                              : const Icon(CupertinoIcons.eye_fill),
                        ),
                      ),
                      validator: (value) =>
                          controller.passwordFieldValidator(value, true),
                      onSaved: (password) => controller.repassword = password!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) =>
                          controller.phoneFieldValidator(value),
                      onSaved: (phone) => controller.phone = phone!,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () => controller.registerUser(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                              child: Center(
                                child: controller.isLoading
                                    ? const MyLoading()
                                    : const Text(
                                        "Register",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have Account?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            goReplace(context, const LoginScreen());
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
