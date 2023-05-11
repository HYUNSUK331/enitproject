import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:enitproject/model/storylist_model.dart';
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
  late Audio audio;

  //싱글톤처럼 쓰기위함
  static StoryController get to => Get.find();

  //데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> storyList = <StoryListModel>[].obs;
  
  //오디오 플레이어
  // final Rx<AudioPlayer> _audioPlayer = AudioPlayer().obs;
  // final Rx<AudioCache> playerCache = AudioCache().obs;
  late Rx<AssetsAudioPlayer> assetsAudioPlayer = AssetsAudioPlayer().obs;

  final Rx<bool> isPlaying = false.obs;

  // Rx<Duration> _duration = Duration().obs;
  // Rx<Duration> _position = Duration().obs;


  @override
  void onInit() async{
    await storyListNetworkRepository.getStoryListModel().then((value) => {
      storyList(value)
    });

    // _audioPlayer.value.onDurationChanged.listen((d) => _duration.value = d);
    // _audioPlayer.value.onPositionChanged
    //     .listen((p) => _position.value = p);
    // _audioPlayer.value.onPlayerStateChanged.listen((PlayerState event) {
    //   isPlaying.value = (event == PlayerState.playing) ? true : false;
    // });

    assetsAudioPlayer.value = AssetsAudioPlayer.newPlayer();

    super.onInit();
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  void onReady() async{
    super.onReady();
  }

  void changeTrueBadgeColor(int index) {
    storyList[index].changeStoryColor = GREEN_BRIGHT_COLOR;
  }

  void changeFalseBadgeColor(int index) {
    storyList[index].changeStoryColor = LIGHT_YELLOW_COLOR;
  }

  void updateLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, true).then((value) async =>
    {
      storyList[index].isLike = true,
      storyList.refresh(),
    });
  }
  void updateUnLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, false).then((value) async =>
    {
      storyList[index].isLike = false,
      storyList.refresh(),
    });
  }

  void setOpenPlay(int index) async {
    String? mp3Path = storyList[index].mp3Path;
    audio = Audio('assets/${mp3Path}',
      metas: Metas(
        title:  storyList[index].title,
        artist: storyList[index].addressSearch,
        image: MetasImage.network('${storyList[index].image}'), //can be MetasImage.network
      ),
    );
    assetsAudioPlayer.refresh();
    await assetsAudioPlayer.value.open(
      audio,
      showNotification: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      autoStart: false,
    );

    BottomPopupPlayerController.to.isPopup(true);
    storyIndex = index;
  }


  String _format(Duration d) {
    String minute =
    int.parse(d.toString().split('.').first.padLeft(8, "0").split(':')[1])
        .toString();
    String second = d.toString().split('.').first.padLeft(8, "0").split(':')[2];
    return ("$minute:$second");
  }

  // set setPositionValue(double value) => assetsAudioPlayer.value.seek(Duration(seconds: value.toInt()));
  // //set setPositionValue(double value) => _audioPlayer.value.seek(Duration(seconds: value.toInt()));
  // double get getDurationAsDouble => _duration.value.inSeconds.toDouble();
  // String get getDurationAsFormatSting => _format(_duration.value);
  // double get getPositionAsDouble => _position.value.inSeconds.toDouble();
  // String get getPositionAsFormatSting => _format(_position.value);

}