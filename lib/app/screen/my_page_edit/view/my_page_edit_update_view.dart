// ignore_for_file: unnecessary_string_interpolations

import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/my_page_edit/controller/my_page_edit_update_controller.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MyPageEditUpdateView extends GetView<MyPageEditUpdateController>{
  const MyPageEditUpdateView({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    final nameFormKey = GlobalKey<FormState>();


    final validNull = RegExp(r"\s+");  //공백
    final validSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]'); // 특수문자
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: IconButton(
            icon: const Icon(LineAwesomeIcons.angle_left),
            color: Colors.black,
            iconSize: 35.0,
            onPressed: () {
              Get.back();
            },
          ),
        ),
        title: Text("My page Edit", style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        children: [
          Form(
            child: TextFormField(
              readOnly: true,
              keyboardType: TextInputType.emailAddress,
              controller: controller.pageEmailController,
              decoration: const InputDecoration(
                fillColor: Colors.red,
                focusColor: Colors.red  ,
                label: Text('Email (변경불가)',style: TextStyle(color: Colors.black,)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,),
          Form(
            key: nameFormKey,
            child: TextFormField(
              controller: controller.pageNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '입력해주세요';
                } else if (validSpecial.hasMatch(value.toString())) {
                  return '특수문자는 불가능 합니다';
                } else if (validNull.hasMatch(value.toString())) {
                  return '공백은 불가능 합니다';
                }
                return null;
              },
              decoration: const InputDecoration(
                label: Text('Name'),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: GREEN_BRIGHT_COLOR,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,),
          Form(
            child: TextFormField(
              readOnly: true,
              controller: controller.pagePasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                // counterText: '',  글자 카운터 지우기
                label: Text('Password (변경불가)',style: TextStyle(color: Colors.black,)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              bool check = true;
              final formKeyState1 = nameFormKey.currentState!;
              if (formKeyState1.validate()) {
                formKeyState1.save();
                check = false;
              }
              if(check == false) {
                Get.back();
                showLogOutDialog();
              }else{}
            },
            child: const Text('수정 완료'),
          ),
        ],
      ),
    );
  }
  void showLogOutDialog() {
    Get.dialog(
        AlertDialog(
          title: const Column(
            children: <Widget>[
              Text("수정 확인"), // 타이틀
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "정말 수정 하시겠습니까?", // 메세지
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: (){
                controller.updateUserName(
                    '${AuthService.to.userModel.value!.userKey}',
                    '${controller.pageNameController.text}');
                controller.pageNameController.clear();
                Get.back();
                },

              child: const Text('예'),
            ),
            TextButton(
              onPressed: (){
                controller.pageNameController.clear();
                Get.back();
              },
              child: const Text('아니요'),
            ),
          ],
        ),
        barrierDismissible: true
    );
  }
}