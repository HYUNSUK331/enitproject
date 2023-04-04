import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/storylist_model.dart';
import '../../service/storylist_network_repository.dart';
import '../story/story_controller.dart';

class PreviewController extends GetxController{

  //싱글톤처럼 쓰기위함
  static PreviewController get to => Get.find();

  //데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> previewStoryList = RxList<StoryListModel>();


  @override
  void onInit() async{
    await storyListNetworkRepository.getStoryListModel().then((value) => {
      previewStoryList(value)
    });

    super.onInit();
  }

  void updateLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, true).then((value) async =>
    {
      previewStoryList[index].isLike = true,
      previewStoryList.refresh(),
      StoryController.to.storyList[index].isLike = true,
      StoryController.to.storyList.refresh()

    });
  }
  void updateUnLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, false).then((value) async =>
    {
      previewStoryList[index].isLike = false,
      previewStoryList.refresh(),
      StoryController.to.storyList[index].isLike = false,
      StoryController.to.storyList.refresh()

    });
  }
}