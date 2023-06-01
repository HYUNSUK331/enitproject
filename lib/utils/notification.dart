import 'package:enitproject/app/screen/story/binding/story_binding.dart';
import 'package:enitproject/app/screen/story/view/story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class NotificationUtils{

  static final notifications = FlutterLocalNotificationsPlugin();


// 앱로드시 실행할 기본설정
  static initNotification(int storyNum) async {

    //안드로이드용 아이콘파일 이름
    var androidSetting = AndroidInitializationSettings('app_icon');

    //ios에서 앱 사용시 유저에게 권한 허가하는 과정
    var iosSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //print("!!!!!!!!!!!!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2");
    // 위에서 설정한 내용으로 초기화 진행
    var initializationSettings = InitializationSettings(
        android: androidSetting,
        iOS: iosSetting
    );
    await notifications.initialize(
      initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async { // 여기서 핸들링!
          print('onDidReceiveNotificationResponse - payload: ${details.payload}');
          Get.to(() => const StoryScreen(), binding: StoryBinding(storyIndex: storyNum,));
          //알림 누를때 함수실행하고 싶으면
          //onSelectNotification: 함수명추가
        }
    );
  }

// 이 함수 원하는 곳에서 실행하면 알림 뜸
  static showNotification(String storyName) async {

    var androidDetails = AndroidNotificationDetails(
      '유니크한 알림 채널 ID',
      '알림종류 설명',
      priority: Priority.high,
      importance: Importance.max,
      enableVibration: true,
      color: Color.fromARGB(255, 255, 0, 0),
    );

    var iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // 알림 id, 제목, 내용 맘대로 채우기
    notifications.show(
        1,
        '제주의 "${storyName} 이야기" ',
        '확인 하시겠습니까?',
        NotificationDetails(android: androidDetails, iOS: iosDetails)
    );
  }

}