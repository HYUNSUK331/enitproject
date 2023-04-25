import 'package:enitproject/model/user_model.dart';
import 'package:enitproject/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  //current Logged in userModel
  Rxn<UserModel> userModel = Rxn<UserModel>();

  //checked login
  RxBool isLoggedIn = false.obs;

  Future<bool> login(String email, String pwd) async {
    EasyLoading.show();
    UserCredential authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pwd).catchError((error) {
      String _message = "";
      switch (error.code.toString()) {
        case 'weak-password':
          _message = "5자리 이상 패스워드를 입력해주세요.";
          break;
        case 'invalid-email':
          _message = "이메일 형식이 다릅니다. 확인 후 다시 시도해주세요.";
          break;
        case 'email-already-in-use':
          _message = "이미 가입된 이메일 주소 입니다. 확인 후 다시 시도해주세요.";
          break;
        default:
          _message = error.code.toString();
      }
      print(_message);
      Get.snackbar(
        'ALERT',
        _message,
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      print(error);
      EasyLoading.dismiss();
      return false;
    });
    print(authResult);

    EasyLoading.dismiss();
    isLoggedIn(true);
    AuthService.to.userModel.value = await userRepository.getUserModel(authResult.user!.uid);
    return true;
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    EasyLoading.show();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if(googleUser == null){
        EasyLoading.dismiss();
        return false;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      if(googleAuth == null){
        EasyLoading.dismiss();
        return false;
      }
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      var value = await FirebaseAuth.instance.signInWithCredential(credential);
      isLoggedIn(true);
      await userRepository.attemptCreateUser(value.user?.uid ?? '', googleUser?.email ?? '', googleUser?.displayName ?? '');
      AuthService.to.userModel.value = await userRepository.getUserModel(value.user!.uid);

      EasyLoading.dismiss();
      // Get.to(()=> Tabs());

      return true;
    } catch (e) {
      EasyLoading.dismiss();
      print("error");
      print(e);
      return false;
    }



  }

  Future<bool> signup(String email, String pwd, String name) async {
    EasyLoading.show();
    UserCredential authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pwd).catchError((error) {
      String _message = "";
      switch (error.code.toString()) {
        case 'weak-password':
          _message = "5자리 이상 패스워드를 입력해주세요.";
          break;
        case 'invalid-email':
          _message = "이메일 형식이 다릅니다. 확인 후 다시 시도해주세요.";
          break;
        case 'email-already-in-use':
          _message = "이미 가입된 이메일 주소 입니다. 확인 후 다시 시도해주세요.";
          break;
        default:
          _message = error.code.toString();
      }
      print(_message);
      EasyLoading.dismiss();
      Get.snackbar(
        'ALERT',
        _message,
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    });

    EasyLoading.dismiss();
    isLoggedIn(true);
    await userRepository.attemptCreateUser(authResult.user!.uid, email, name);
    AuthService.to.userModel.value = await userRepository.getUserModel(authResult.user!.uid);
    return true;
  }

  Future<void> logout() async {

    await FirebaseAuth.instance.signOut();
    isLoggedIn(false);
  }

  /// 회원탈퇴
  Future<void> withdrawal({required BuildContext context, required String email, required String password}) async {
    UserCredential authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password.trim()).catchError(
      (error) {
        String _message = "";
        switch (error.code) {
          case 'invalid-email':
            _message = '정확한 이메일 주소를 입력하세요.';
            break;
          case 'user-disabled':
            _message = 'user-disabled';
            break;
          case 'user-not-found':
            _message = '가입되지 않은 이메일이거나 비밀번호가 틀렸습니다.';
            break;
          case 'wrong-password':
            _message = '비밀번호를 확인해주세요.';
            break;
        }

        print(_message);

      },
    );

    if (authResult.user == null) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please try again later!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // await userRepository.deleteUserModel(userKey: AuthService.to.userModel.value!.userKey); //db delete
      // await FirebaseAuth.instance.currentUser?.delete();//auth delete
    }
  }
}
