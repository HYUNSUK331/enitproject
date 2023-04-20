import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/app/root_screen.dart';
import 'package:enitproject/const/const.dart';
import 'package:enitproject/firebase_options.dart';
import 'package:enitproject/notification.dart';
import 'package:enitproject/screen/bottom_popup_player/bottom_popup_player_controller.dart';
import 'package:enitproject/screen/map_home/map_home_controller.dart';
import 'package:enitproject/screen/story/story_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void main() async{

  //비동기로 데이터를 다룬 다음 runapp할 경우 사용
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // notification 초기화
  await initNotification();

  Get.put(StoryController());
  Get.put(BottomPopupPlayerController());
  Get.put(MapHomeController());
  configLoading();

  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });

  runApp(RootView());
}
