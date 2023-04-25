import 'package:enitproject/app/tab/tabs_binding.dart';
import 'package:enitproject/app/tab/tabs_screen.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: controller.emailController,
            decoration: const InputDecoration(label: Text('Email')),
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            controller: controller.passwordController,
            decoration: const InputDecoration(label: Text('Password')),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await AuthService.to.login(controller.emailController.text, controller.passwordController.text).then((value) => {
                    value
                        ? Get.to(()=>const TabsView(), binding: TabsBinding())
                        : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("error"), duration: Duration(milliseconds: 1000)))
                  });
            },
            child: const Text('로그인'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await AuthService.to.signInWithGoogle(context).then((value) => {
                value
                    ? Get.to(()=>const TabsView(), binding: TabsBinding())
                    : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("error"), duration: Duration(milliseconds: 1000)))
              });
            },
            child: const Text('구글로 로그인'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              AuthService.to.signup(controller.emailController.text, controller.passwordController.text, "test").then((value) => {
                    value
                        ? Get.to(()=>const TabsView(), binding: TabsBinding())
                        : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("error"), duration: Duration(milliseconds: 1000)))
                  });
            },
            child: const Text('회원가입'),
          ),
        ],
      ),
    );
  }
}
