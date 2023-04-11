import 'package:audioplayers/audioplayers.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/screen/preview/preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../const/color.dart';
import '../../const/const.dart';
import '../../service/storylist_network_repository.dart';
import '../bottom_popup_player/bottom_popup_player_controller.dart';

class StoryController extends GetxController{

  late String storyIDkey;

  //싱글톤처럼 쓰기위함
  static StoryController get to => Get.find();

  //데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> storyList = <StoryListModel>[].obs;
  
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

    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
    });

    // audioPlayer.onDurationChanged.listen((newDuration) {
    //   //duration = newDuration;
    //   duration(newDuration);
    // });
    //
    // audioPlayer.onPositionChanged.listen((newPosition) {
    //   //position = newPosition;
    //   position(newPosition);
    // });

    super.onInit();
  }

  @override
  void onReady() async{
    audioPlayer.release();
    audioPlayer.dispose();
    super.onReady();
  }

  void changeTrueBadgeColor(int index) {
    storyList[index].changeStoryColor = GREEN_BRIGHT_COLOR;
    //storyList.refresh();
    //return GREEN_BRIGHT_COLOR;
  }

  void changeFalseBadgeColor(int index) {
    storyList[index].changeStoryColor = LIGHT_YELLOW_COLOR;
    //storyList.refresh();
    //return LIGHT_YELLOW_COLOR;
  }

  void updateLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, true).then((value) async =>
    {
      storyList[index].isLike = true,
      storyList.refresh(),
      // PreviewController.to.previewStoryList[index].isLike = true,
      // PreviewController.to.previewStoryList.refresh()

    });
  }
  void updateUnLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, false).then((value) async =>
    {
      storyList[index].isLike = false,
      storyList.refresh(),
      // PreviewController.to.previewStoryList[index].isLike = false,
      // PreviewController.to.previewStoryList.refresh()

    });
  }

  void updatePause() async{
    await audioPlayer.pause();
    isPlaying(false);
    isPlaying.refresh();
    // PreviewController.to.isPlaying(false);
    // PreviewController.to.isPlaying.refresh();
  }

  void updatePlay(int index) async{
    String? mp3Path = storyList[index].mp3Path;
    await audioPlayer.play(AssetSource(mp3Path!));
    isPlaying(true);
    isPlaying.refresh();
    BottomPopupPlayerController.to.isPopup(true);
    // BottomPopupPlayerController.to.isPopup.refresh();
    BottomPopupPlayerController.to.setPopupTitle = '${storyList[index].title}';
    BottomPopupPlayerController.to.setPopupImage = '${storyList[index].image}';
    BottomPopupPlayerController.to.setPopupAddressDetail = '${storyList[index].addressDetail}';
    BottomPopupPlayerController.to.setPopupPath = mp3Path;
    storyIndex = index;
    // PreviewController.to.isPlaying(true);
    // PreviewController.to.isPlaying.refresh();
  }

}