import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final signupEmailController = TextEditingController();  // TextEditingController는 편집이 가능한 TextField에 입력된 값을 가지고 오거나 TextField에 입력된 값이 변경될때 사용 하는 클래스
  final signupPasswordController = TextEditingController();
  final signupPasswordCheckController = TextEditingController();
  final signupNameController = TextEditingController();
}