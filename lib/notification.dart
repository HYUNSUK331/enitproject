import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification{
  Future<void> initNotiSetting()async{
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final AndroidInitializationSettings initSettingsAndroid = AndroidInitializationSettings('ic_launcher');

    final DarwinInitializationSettings initSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false, requestBadgePermission: false, requestAlertPermission: false);

    final InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid, iOS: initSettingsIOS,
    );

    // await flutterLocalNotificationsPlugin.initialize(initSettings, onDidReceiveNotificationResponse: []);
  }
}