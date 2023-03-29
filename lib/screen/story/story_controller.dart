import 'package:enitproject/model/storylist_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:just_audio/just_audio.dart';

import '../../service/storylist_network_repository.dart';

class StoryController extends GetxController{

  //싱글톤처럼 쓰기위함
  static StoryController get to => Get.find();

  //데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> storyList = RxList<StoryListModel>();
  
  //오디오 플레이어
  final audioPlayer = AudioPlayer();

  @override
  void onInit() async{
    await storyListNetworkRepository.getStoryListModel().then((value) => {
      storyList(value)
    });
    _init();
    
    super.onInit();
  }

  @override
  void onReady() async{
    audioPlayer.dispose();
    super.onReady();
  }

  Future<void> _init() async {
    // Listen to errors during playback.
    audioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      await audioPlayer.setAudioSource(AudioSource.asset('assets/audio/story_1.mp3'));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }


}