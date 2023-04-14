import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BottomPopupPlayerController extends GetxController{

  //싱글톤처럼 쓰기위함
  static BottomPopupPlayerController get to => Get.find();

  RxBool isPopup = RxBool(false);

  set setIsPopup(bool value){
    isPopup(value);
  }

}