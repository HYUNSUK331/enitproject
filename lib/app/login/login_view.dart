import 'package:enitproject/app/tab/tabs_binding.dart';
import 'package:enitproject/app/tab/tabs_screen.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

/// 로그인 화면
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
            keyboardType: TextInputType.emailAddress,  //이메일 타입 알아서 검사해주는 친구
            controller: controller.emailController,
            decoration: const InputDecoration(label: Text('Email')),
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true, // 글자를 암호화 해주는 명령어
            controller: controller.passwordController,
            decoration: const InputDecoration(label: Text('Password')),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await AuthService.to.login(controller.emailController.text, controller.passwordController.text).then((value) => {  // 버튼을 눌렀을 때 해당 내용이 맞지 않으면 출력할 text들이 AuthService 내부에 정의 되어있다.
                    value
                        ? Get.to(()=>const TabsView(), binding: TabsBinding())  //로그인 되면 TabsView로 이동 아니면 error 띄우기
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
                    ? Get.to(()=>const TabsView(), binding: TabsBinding())   //로그인 되면 TabsView로 이동 아니면 error 띄우기
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
