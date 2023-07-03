import 'package:get/get.dart';

class BottomPopupPlayerController extends GetxController{

  //싱글톤처럼 쓰기위함
  static BottomPopupPlayerController get to => Get.find();

  RxBool isPopup = RxBool(false);

  set setIsPopup(bool value){
    isPopup(value);
  }

}