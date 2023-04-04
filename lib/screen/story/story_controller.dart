import 'package:audioplayers/audioplayers.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/screen/preview/preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../service/storylist_network_repository.dart';

class StoryController extends GetxController{

  //싱글톤처럼 쓰기위함
  static StoryController get to => Get.find();

  //데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> storyList = RxList<StoryListModel>();
  
  //오디오 플레이어
  final audioPlayer = AudioPlayer();

  RxBool isPlaying = RxBool(false);
  // Duration duration = Duration.zero;
  // Duration position = Duration.zero;


  Rx<Duration> duration = Rx<Duration>(Duration.zero);
  Rx<Duration> position = Rx<Duration>(Duration.zero);

  @override
  void onInit() async{
    await storyListNetworkRepository.getStoryListModel().then((value) => {
      storyList(value)
    });
    
    audioPlayer.onDurationChanged.listen((newDuration) {
      //duration = newDuration;
      duration(newDuration);
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      //position = newPosition;
      position(newPosition);
    });

    super.onInit();
  }

  @override
  void onReady() async{
    audioPlayer.dispose();
    super.onReady();
  }
  
  void updateLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, true).then((value) async =>
    {
      storyList[index].isLike = true,
      storyList.refresh(),
      PreviewController.to.previewStoryList[index].isLike = true,
      PreviewController.to.previewStoryList.refresh()

    });
  }
  void updateUnLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, false).then((value) async =>
    {
      storyList[index].isLike = false,
      storyList.refresh(),
      PreviewController.to.previewStoryList[index].isLike = false,
      PreviewController.to.previewStoryList.refresh()

    });
  }

  void updatePause() async{
    await audioPlayer.pause();
    isPlaying(false);
    isPlaying.refresh();
  }

  void updatePlay(int index) async{
    String? mp3Path = storyList[index].mp3Path;
    await audioPlayer.play(AssetSource(mp3Path!));
    isPlaying(true);
    isPlaying.refresh();
  }

}