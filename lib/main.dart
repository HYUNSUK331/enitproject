import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/const/const.dart';
import 'package:enitproject/firebase_options.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:enitproject/service/splash_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Future<void> main() async{

  //비동기로 데이터를 다룬 다음 runapp할 경우 사용
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /// 알림창 초기화

  /// 로딩화면 설정
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();


  /// 로딩표시
  configLoading();

  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });

  runApp(
    GetMaterialApp.router(
      initialBinding: BindingsBuilder(() {  // 초기화 하면서 서비스를 가져온다.
          Get.put(SplashService());
          Get.put(AuthService());
          Get.put(StoryService());
        },
      ),
      builder: EasyLoading.init(),
      getPages: AppPages.routes,
    ),
  );
}

