import 'package:audioplayers/audioplayers.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/repository/storylist_network_repository.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PreviewController extends GetxController{

  //싱글톤처럼 쓰기위함
  static PreviewController get to => Get.find();

  //데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> previewStoryList = RxList<StoryListModel>();

  //story에 있는 컬렉션만큼 boollist 만들어 주는 클래스
  RxList invisibleTableRowSwitchList = RxList<dynamic>();

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
      previewStoryList(value),
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

  void buildInvisibleTableRowSwitch(int switchLength) {
    invisibleTableRowSwitchList = RxList<bool>.generate(switchLength, (int index) => false, growable: true);
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
  /// 질문2 여기서 => 는 awit이 완료되고 아래 명령어 실행하는건지 궁금합니다.
  /// 즉 리포짓토리에 먼저 다 넣고 아래 것들 리턴해주는 건지 궁금해요 그럼 DB바꾸고 나서  local바꿔주는 건지
  void updateUnLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, false).then((value) async =>
    {
      previewStoryList[index].isLike = false,
      previewStoryList.refresh(),
      StoryController.to.storyList[index].isLike = false,
      StoryController.to.storyList.refresh()
    });
  }

  void updatePlay(int index) async{
    String? mp3Path = previewStoryList[index].mp3Path;
    await audioPlayer.play(AssetSource(mp3Path!));
    isPlaying(true);
    isPlaying.refresh();
    StoryController.to.isPlaying(true);
    StoryController.to.isPlaying.refresh();
  }

  void updatePause() async{
    await audioPlayer.pause();
    isPlaying(false);
    isPlaying.refresh();
    StoryController.to.isPlaying(false);
    StoryController.to.isPlaying.refresh();
  }
}