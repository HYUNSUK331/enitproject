import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/signup/controller/signup_controller.dart';
import 'package:enitproject/app/screen/tab/binding/tabs_binding.dart';
import 'package:enitproject/app/screen/tab/view/tabs_screen.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _enailFormKey = GlobalKey<FormState>();
    final _passwordFormKey = GlobalKey<FormState>();
    final _nameFormKey = GlobalKey<FormState>();
    final _passwordCheckFormKey = GlobalKey<FormState>();
    final _phoneNumFormKey = GlobalKey<FormState>();
    // final riKey1 = const Key('__RIKEY1__');
    // final riKey2 = const Key('__RIKEY2__');
    // final riKey3 = const Key('__RIKEY3__');
    // final riKey4 = const Key('__RIKEY4__');
    // final riKey5 = const Key('__RIKEY5__');


    final validNumbers = RegExp(r'(\d+)');  //숫자
    final validAlphabet = RegExp(r'[a-zA-Z]');  //영어
    final validSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]'); // 특수문자
    final validNull = RegExp(r"\s+");  //공백
    final validPhoneNum = RegExp(r"^010-?([0-9]{4})-?([0-9]{4})$"); // 전화번호
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp emailRegExp = RegExp(pattern.toString());  // 이메일 형식

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: ()=>{ Get.rootDelegate.popRoute()},),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        children: [
          Form(
            key: _enailFormKey,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: controller.signupEmailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '입력해주세요';
                } else if (!emailRegExp.hasMatch(value.toString())) {
                  return '이메일 형식이 잘못되었습니다';
                }
              },
              decoration: const InputDecoration(
                label: Text('Email'),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Form(
            key: _nameFormKey,
            child: TextFormField(
              controller: controller.signupNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '입력해주세요';
                } else if (validSpecial.hasMatch(value.toString())) {
                  return '특수문자는 불가능 합니다';
                } else if (validNull.hasMatch(value.toString())) {
                  return '공백은 불가능 합니다';
                }
              },
              decoration: const InputDecoration(
                label: Text('Name'),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Form(
            key: _passwordFormKey,
            child: TextFormField(
              controller: controller.signupPasswordController,
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
          SizedBox(
            height: 20.0,
          ),
          Form(
            key: _passwordCheckFormKey,
            child: TextFormField(
              obscureText: true,
              controller: controller.signupPasswordCheckController,
              validator: (value) {
                if (value != controller.signupPasswordController.text) {
                  return '비밀번호가 일치 하지 않습니다.';
                }
              },
              maxLength: 15,
              decoration: const InputDecoration(
                label: Text('PasswordCheck (6~15)'),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Form(
            key: _phoneNumFormKey,
            child: TextFormField(
              controller: controller.signupPhoneNumController,
              validator: (value){
                if(!validPhoneNum.hasMatch(value.toString())){
                  return '01012345678 형식으로 작성해주세요';
                }
              },
              decoration: const InputDecoration(
                label: Text('PhoneNumber(- 없이)'),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextButton(
            //
            onPressed: () async {
              /// Email 입력오류 창
              final formKeyState = _enailFormKey.currentState!;
              if (formKeyState.validate()) {
                formKeyState.save();
              }
              /// pwd 입력오류 창
              final formKeyState1 = _nameFormKey.currentState!;
              if (formKeyState1.validate()) {
                formKeyState1.save();
              }
              /// pwd 입력오류 창
              final formKeyState2 = _passwordFormKey.currentState!;
              if (formKeyState2.validate()) {
                formKeyState2.save();
              }
              /// pwd 입력오류 창
              final formKeyState3 = _passwordCheckFormKey.currentState!;
              if (formKeyState3.validate()) {
                formKeyState3.save();
              }
              /// pwd 입력오류 창
              final formKeyState4 = _phoneNumFormKey.currentState!;
              if (formKeyState4.validate()) {
                formKeyState4.save();
              }
              AuthService.to
                  .signup(
                      controller.signupEmailController.text,
                      controller.signupPasswordController.text,
                      controller.signupPasswordCheckController.text,
                      controller.signupNameController.text,
                      controller.signupPhoneNumController.text)
                  .then((value) => {
                        value
                            ? showDialog(
                                context: context,
                                barrierDismissible: false, // 다른 화면 터치 X
                                builder: (context) {
                                  ///모달창
                                  print(
                                      '##########################################$value');
                                  return AlertDialog(
                                    title: Column(
                                      children: <Widget>[
                                        new Text("회원가입 완료"), // 타이틀
                                      ],
                                    ),
                                    //
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${controller.signupNameController.text}님 회원 가입을 축하드립니다.", // 메세지
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("확인"),
                                        onPressed: () {
                                          controller.signupPasswordController
                                              .clear();
                                          controller.signupNameController
                                              .clear();
                                          controller.signupPhoneNumController
                                              .clear();
                                          controller
                                              .signupPasswordCheckController
                                              .clear();
                                          controller.signupEmailController
                                              .clear();
                                          Get.rootDelegate.toNamed(Routes.TAB);
                                          // Get.to(() => const TabsView(),
                                          //     binding:
                                          //         TabsBinding()); //누르면 메인화면으로 이동
                                        },
                                      ),
                                    ],
                                  );
                                })
                            : {} //로그인 실패하면 아무것도 안하기
                      });
            },
            child: const Text('회원가입'),
          ),
        ],
      ),
    );
  }
}
