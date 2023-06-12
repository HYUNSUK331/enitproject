import 'package:enitproject/model/user_model.dart';
import 'package:enitproject/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  /// current Logged in userModel
  Rxn<UserModel> userModel = Rxn<UserModel>(); // n은 널을 뜻함 / 초기값이 없으면 null
  // storyListNetworkRepository.getStoryListModel()

  /// checked login
  RxBool isLoggedIn = false.obs;

  /// 로그인 관련
  /// 발생하는 에러코드를 캐치해서 메세지로 출력해준다.
  /// 메세지는 하단에서 올라옴
  Future<bool> login(String email, String pwd) async {
    EasyLoading.show();
    UserCredential authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: pwd,
    )
        .catchError((error) {
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
    AuthService.to.userModel.value =
        await userRepository.getUserModel(authResult.user!.uid);
    print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh${AuthService.to.userModel.value}");
    return true;
  }

  /// 구글 로그인 관련
  Future<bool> signInWithGoogle(BuildContext context) async {
    EasyLoading.show();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        EasyLoading.dismiss();
        return false;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // if (googleAuth == null) {
      //   EasyLoading.dismiss();
      //   return false;
      // }
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      var value = await FirebaseAuth.instance.signInWithCredential(credential);
      isLoggedIn(true); // 로그인 했다!!!
      await userRepository.googleAttemptCreateUser(
        value.user?.uid ?? '',
        googleUser.email ?? '',
        googleUser.displayName ?? '',
      );
      AuthService.to.userModel.value =
          await userRepository.getUserModel(value.user!.uid);

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

  /// 회원가입 관련
  /// 여기 순서가 너무 중요하다!! auth 인증되는 곳을 집중해서 봐야된다.
  Future<bool> signup(String email, String pwd, String pwdCk, String name,
      String phoneNum) async {
    EasyLoading.show();
    String _message = "";

    final validNumbers = RegExp(r'(\d+)'); // 숫자만
    final validAlphabet = RegExp(r'[a-zA-Z]'); // 영어
    final validSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]'); // 특수문자
    final validNull = RegExp(r"\s+"); //공백
    final validPhoneNum = RegExp(r"^010-?([0-9]{4})-?([0-9]{4})$");  // 전화번호
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp emailRegExp = RegExp(pattern.toString()); // 이메일 패턴
    /// 빈칸 검사
    if (email.isEmpty || pwd.isEmpty || name.isEmpty || pwdCk.isEmpty) {
      EasyLoading.dismiss();
      Get.snackbar(
        'ALERT',
        '빈칸은 없어야 합니다',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }

    /// Email 조건
    /// 이메일 형식 맞추기
    else if (!emailRegExp.hasMatch(email)) {
      EasyLoading.dismiss();
      Get.snackbar(
        'ALERT',
        '이메일 형식을 맞춰주세요.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }

    /// Name 조건
    /// 특수문자 조건
    else if (validSpecial.hasMatch(name)) {
      EasyLoading.dismiss();
      Get.snackbar(
        'ALERT',
        '특수문자는 불가능합니다.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }

    ///공백 조건
    else if (validNull.hasMatch(name)) {
      EasyLoading.dismiss();
      Get.snackbar(
        'ALERT',
        '공백은 불가능합니다.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }

    /// 비밀번호 조건
    /// 비밀번호 숫자 없을 때
    else if (!validNumbers.hasMatch(pwd)) {
      EasyLoading.dismiss();
      Get.snackbar(
        'ALERT',
        '비밀번호에 숫자가 없습니다.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }

    /// 비밀번호 영어 없을 때
    else if (!validAlphabet.hasMatch(pwd)) {
      EasyLoading.dismiss();
      Get.snackbar(
        'ALERT',
        '비밀번호에 영어가 없습니다.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }
    // /// 비밀번호 특수문자 없을 때
    // else if(!validSpecial.hasMatch(pwd)){
    //   EasyLoading.dismiss();
    //   Get.snackbar(
    //     'ALERT',
    //     '비밀번호에 특수 문자가 없습니다.',
    //     snackPosition: SnackPosition.BOTTOM,
    //     forwardAnimationCurve: Curves.elasticInOut,
    //     reverseAnimationCurve: Curves.easeOut,
    //   );
    //   return false;
    // }

    /// 비밀번호 공백여부
    else if (validNull.hasMatch(pwd)) {
      EasyLoading.dismiss();
      Get.snackbar(
        'ALERT',
        '공백은 불가능합니다.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }

    /// 1,2차 비밀번호가 다르면
    else if (pwd != pwdCk) {
      EasyLoading.dismiss();
      Get.snackbar(
        'ALERT',
        '2차 비밀번호가 다릅니다.',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }

    /// 전화번호 검증
    /// -포함
    else if (!validPhoneNum.hasMatch(phoneNum)) {
      EasyLoading.dismiss();
      Get.snackbar(
        'ALERT',
        '01012345678 형식이어야 합니다',
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.elasticInOut,
        reverseAnimationCurve: Curves.easeOut,
      );
      return false;
    }

    /// auth에 저장하는 과정
    else {
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd)
          .catchError((error) {
        //에러가 생길때만 들어온다. / 여기 문제 없이 지나가면 auth에 등록된다.
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

      /// 모든 과정을 통과하면 true를 반환
      EasyLoading.dismiss();
      isLoggedIn(true);
      await userRepository.attemptCreateUser(
          authResult.user!.uid, email, name, phoneNum);
      AuthService.to.userModel.value =
          await userRepository.getUserModel(authResult.user!.uid);

      return true;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    isLoggedIn(false);
  }

  /// 회원탈퇴
  Future<void> withdrawal(
      {required BuildContext context,
      required String email,
      required String password}) async {
    UserCredential authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError(
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
