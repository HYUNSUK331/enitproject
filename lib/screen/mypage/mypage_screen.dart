import 'package:enitproject/app/login/login_controller.dart';
import 'package:enitproject/app/login/login_view.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({Key? key}) : super(key: key);

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MYPAGE"),),
      body: TextButton(
        onPressed: () {
          AuthService.to.logout();
          Get.put(LoginController());
          Get.offAll(const LoginView());
        },
        child: Text("LOGOUT"),
      ),
    );
  }
}
