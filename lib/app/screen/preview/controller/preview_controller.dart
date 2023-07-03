import 'package:audioplayers/audioplayers.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/repository/storylist_network_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PreviewController extends GetxController{

  //싱글톤처럼 쓰기위함
  static PreviewController get to => Get.find();

  //데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> previewStoryList = RxList<StoryListModel>();
  // //story에 있는 컬렉션만큼 boollist 만들어 주는 클래스
  // RxList invisibleTableRowSwitchList = RxList<dynamic>();

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
  // /// boollist만들기
  // void buildInvisibleTableRowSwitch(int switchLength) {
  //   invisibleTableRowSwitchList = RxList<bool>.generate(switchLength, (int index) => false, growable: true);
  // }


  void updatePlay(int index) async{
    String? mp3Path = previewStoryList[index].mp3Path;
    await audioPlayer.play(AssetSource(mp3Path!));
    isPlaying(true);
    isPlaying.refresh();
    StoryService.to.isPlaying(true);
    StoryService.to.isPlaying.refresh();
  }

  void updatePause() async{
    await audioPlayer.pause();
    isPlaying(false);
    isPlaying.refresh();
    StoryService.to.isPlaying(false);
    StoryService.to.isPlaying.refresh();
  }

  ///관심목록 리스트랑 이야기 리스트의 인덱스가 달라서
  ///선택된 리스트 인덱스번째의 키값과 이야기의 키값 대조해서 같은 키값을 가진 이야기리스트의 인덱스를 찾아서
  ///int 'storykey'로 뺴줌
  int storykey(int index) {
    late int key;
    for (int i = 0; i < StoryService.to.storyList.length; i++) {
      if (previewStoryList[index].storyPlayListKey ==
          StoryService.to.storyList[i].storyPlayListKey) {
        key = i;
      }
    }
    return key;
  }

}