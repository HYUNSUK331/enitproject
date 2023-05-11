import 'dart:async';
import 'package:async/async.dart';
import 'package:enitproject/repository/user_repository.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashService extends GetxService {
  static SplashService get to => Get.find();

  // 특정위젯의 rebuild를 피하게 해주는 기능 AsyncMemoizer
  final memo = AsyncMemoizer<void>();
  Future<void> init() {  //future는 비동기 통신을 위한 것 void는 return을 받아야한다.
    // runOnce 안에 rebuild가 되지 않아야 하는 함수를 넣는다.
    return memo.runOnce(_initFunction);
  }

  // rebuild가 되지 않아야 하는 함수 작성
  Future<void> _initFunction() async {
    print("COME");
    AuthService.to.isLoggedIn(FirebaseAuth.instance.currentUser!=null);  // AuthService는 로그인 인증을 하는 과정 / 유저가 null이 아니라면
    if(AuthService.to.isLoggedIn.value) {  //로그인이 되었는지 확인하고 확인되면 DB에서 유저 정보가져오기
      AuthService.to.userModel.value = await userRepository.getUserModel(FirebaseAuth.instance.currentUser!.uid);
    }
  }
}
