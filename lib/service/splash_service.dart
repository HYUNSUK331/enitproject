import 'dart:async';
import 'package:async/async.dart';
import 'package:enitproject/repository/user_repository.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashService extends GetxService {
  static SplashService get to => Get.find();

  final memo = AsyncMemoizer<void>();
  Future<void> init() {
    return memo.runOnce(_initFunction);
  }
  Future<void> _initFunction() async {
    print("COME");
    AuthService.to.isLoggedIn(FirebaseAuth.instance.currentUser!=null);
    if(AuthService.to.isLoggedIn.value) {

      // appInfoNetworkRepo.getAppInfo(context),
    // userNetworkRepo.getAllUserModel(),

      AuthService.to.userModel.value = await userRepository.getUserModel(FirebaseAuth.instance.currentUser!.uid);
    }
  }
}
