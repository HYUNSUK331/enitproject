import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class BottomPopupPlayerController extends GetxController{

  //싱글톤처럼 쓰기위함
  static BottomPopupPlayerController get to => Get.find();

  RxBool isPopup = RxBool(false);
  RxString popupImage = RxString('String image');
  RxString popupTitle = RxString('String title');
  RxString popupAddressDetail = RxString('String addressDetail');
  RxString popupPath = RxString('String path');

  set setIsPopup(bool value){
    isPopup(value);
  }

  set setPopupImage(String image){
    popupImage(image);
  }

  set setPopupTitle(String title){
    popupTitle(title);
  }

  set setPopupAddressDetail(String addressDetail){
    popupAddressDetail(addressDetail);
  }

  set setPopupPath(String path){
    popupPath(path);
  }
}