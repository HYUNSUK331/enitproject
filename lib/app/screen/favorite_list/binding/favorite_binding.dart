import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:enitproject/app/screen/favorite_list/controller/favorite_controller.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:get/get.dart';

class FavoriteListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavoriteController>(FavoriteController());
    Get.put<StoryService>(StoryService());
    Get.put<BottomPopupPlayerController>(BottomPopupPlayerController());
  }
}
