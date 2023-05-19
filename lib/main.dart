import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/app/login/login_controller.dart';
import 'package:enitproject/app/root_screen.dart';
import 'package:enitproject/const/const.dart';
import 'package:enitproject/firebase_options.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:enitproject/service/splash_service.dart';
import 'package:enitproject/utils/notification.dart';
import 'package:enitproject/screen/bottom_popup_player/bottom_popup_player_controller.dart';
import 'package:enitproject/screen/map_home/map_home_controller.dart';
import 'package:enitproject/screen/story/story_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async{

  //비동기로 데이터를 다룬 다음 runapp할 경우 사용
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /// 알림창 초기화
  await NotificationUtils.initNotification();

  /// 로딩화면 설정
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(seconds: 1));  //1초 그냥 딜레이 주기 / 안줘도 될듯...?

  /// controller
  Get.put(StoryController());
  Get.put(BottomPopupPlayerController());
  Get.put(MapHomeController());

  /// 인증을 위한 컨트롤러
  Get.put(AuthService());
  /// 특정위젯의 rebuild를 피하게 해주는 기능
  Get.put(SplashService());


  /// 로딩표시
  configLoading();

  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });

  runApp(const RootView());
}

