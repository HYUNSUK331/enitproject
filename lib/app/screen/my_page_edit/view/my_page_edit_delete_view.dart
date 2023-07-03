import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/my_page_edit/controller/my_page_edit_delete_controller.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MyPageEditDeleteView extends GetView<MyPageEditDeleteController>{
  const MyPageEditDeleteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final enailFormKey = GlobalKey<FormState>();
    final passwordFormKey = GlobalKey<FormState>();

    final validNumbers = RegExp(r'(\d+)');  //숫자
    final validAlphabet = RegExp(r'[a-zA-Z]');  //영어
    final validNull = RegExp(r"\s+");  //공백
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp emailRegExp = RegExp(pattern.toString());  // 이메일 형식
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
            key: enailFormKey,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: controller.pageEmailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '입력해주세요';
                } else if (!emailRegExp.hasMatch(value.toString())) {
                  return '이메일 형식이 잘못되었습니다';
                }
                return null;
              },
              decoration: const InputDecoration(
                label: Text('Email'),
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
            key: passwordFormKey,
            child: TextFormField(
              controller: controller.pagePasswordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '입력해주세요';
                } else if (!validNumbers.hasMatch(value.toString())) {
                  return '숫자가 없습니다';
                } else if (!validAlphabet.hasMatch(value.toString())) {
                  return '영어가 없습니다';
                }
                // else if (!validSpecial.hasMatch(value.toString())) {
                //   return '특수문자가 없습니다';
                // }
                else if (validNull.hasMatch(value.toString())) {
                  return '공백은 불가능 합니다.';
                }
                return null;
              },
              obscureText: true,
              // *로 바꿔주기
              maxLength: 15,
              // 글자수 제한
              // inputFormatters: [
              //   FilteringTextInputFormatter(filterPattern, allow: allow)  // 정규표현식으로 제한두기
              // ],
              decoration: const InputDecoration(
                // counterText: '',  글자 카운터 지우기
                label: Text('Password (6~15자)'),
                focusedBorder: OutlineInputBorder(
                  // 클릭시 주황색 테두리로 변화주기
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            //
            onPressed: () async {
              /// Email 입력오류 창
              final formKeyState = enailFormKey.currentState!;
              final formKeyState2 = passwordFormKey.currentState!;

              if (formKeyState.validate()) {
                formKeyState.save();
              }
              /// pwd 입력오류 창
              else if (formKeyState2.validate()) {
                formKeyState2.save();
              }
              // Get.back();  /// 여기서 Get.back해야한다.
              AuthService.to
                  .withdrawal(
                  controller.pageEmailController.text,
                  controller.pagePasswordController.text)
                   .then((value) =>
              {
                value
                    ? showLogOutDialog()
                    : {} ///로그인 실패하면 알림 띄우기
              });
            },
            child: const Text('회원 탈퇴'),
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
              Text("탈퇴 완료"), // 타이틀
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "탈퇴 ㅃ2", // 메세지
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: (){
                Get.rootDelegate.offAndToNamed(Routes.LOGIN);
              },
              child: const Text('cancel'),
            ),
          ],
        ),
        barrierDismissible: true
    );
  }
}