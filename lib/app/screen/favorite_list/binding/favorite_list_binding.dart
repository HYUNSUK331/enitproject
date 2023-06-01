import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:enitproject/app/screen/favorite_list/controller/favorite_list_controller.dart';
import 'package:enitproject/app/screen/user/controller/user_controller.dart';
import 'package:get/get.dart';

class FavoriteListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavoriteListController>(FavoriteListController());

    Get.put<UserController>(UserController());
    Get.put<BottomPopupPlayerController>(BottomPopupPlayerController());
  }
}
