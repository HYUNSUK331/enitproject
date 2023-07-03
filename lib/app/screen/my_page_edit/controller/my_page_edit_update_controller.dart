import 'package:enitproject/repository/user_repository.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPageEditUpdateController extends GetxController {

  static MyPageEditUpdateController get to => Get.find();

  bool updateCheck = false;
  @override
  void onInit() async {
    super.onInit();
  }
  final pageEmailController = TextEditingController(text: "${AuthService.to.userModel.value!.email}");  // TextEditingController는 편집이 가능한 TextField에 입력된 값을 가지고 오거나 TextField에 입력된 값이 변경될때 사용 하는 클래스
  final pagePasswordController = TextEditingController(text: "****");
  final pageNameController = TextEditingController();


  /// user unfav update 하기
  void updateUserName(String userKey, String name) async {
    if(AuthService.to.userModel.value != null){
      AuthService.to.userModel.value?.name = name;
      AuthService.to.userModel.refresh();
    }
    userRepository.updateUserName(userKey,name);
  }

}