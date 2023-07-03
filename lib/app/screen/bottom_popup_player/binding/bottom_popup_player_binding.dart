import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:get/get.dart';

class BottomPopupPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BottomPopupPlayerController>(BottomPopupPlayerController());
  }
}
