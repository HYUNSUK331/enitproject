import 'package:enitproject/app/screen/favorite_list/controller/favorite_controller.dart';
import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/tab/controller/tabs_controller.dart';
import 'package:enitproject/app/screen/user/controller/user_controller.dart';
import 'package:get/get.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TabsController>(TabsController());
    Get.put<MapHomeController>(MapHomeController());
    Get.put<FavoriteController>(FavoriteController());
    Get.put<StoryController>(StoryController());
    Get.put<UserController>(UserController());
  }
}
