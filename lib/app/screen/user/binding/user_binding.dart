import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:enitproject/app/screen/login/controller/login_controller.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/user/controller/user_controller.dart';
import 'package:get/get.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserController>(UserController());
  }
}
