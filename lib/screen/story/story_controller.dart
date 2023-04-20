// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
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

  //싱글톤처럼 쓰기위함
  static StoryController get to => Get.find();

  //데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> storyList = <StoryListModel>[].obs;
  
  //오디오 플레이어
  final Rx<AudioPlayer> _audioPlayer = AudioPlayer().obs;
  final Rx<AudioCache> playerCache = AudioCache().obs;
  //late Rx<AssetsAudioPlayer> _assetsAudioPlayer = AssetsAudioPlayer().obs;

  final Rx<bool> isPlaying = false.obs;

  Rx<Duration> _duration = Duration().obs;
  Rx<Duration> _position = Duration().obs;


  @override
  void onInit() async{
    await storyListNetworkRepository.getStoryListModel().then((value) => {
      storyList(value)
    });

    _audioPlayer.value.onDurationChanged.listen((d) => _duration.value = d);
    _audioPlayer.value.onPositionChanged
        .listen((p) => _position.value = p);
    _audioPlayer.value.onPlayerStateChanged.listen((PlayerState event) {
      isPlaying.value = (event == PlayerState.playing) ? true : false;
    });

    //_assetsAudioPlayer.value = AssetsAudioPlayer.newPlayer();

    super.onInit();
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

  void updatePlay(int index) async {
    if (isPlaying.value) {
      _audioPlayer.value.pause();
      //_assetsAudioPlayer.value.pause();
    } else {
      String? mp3Path = storyList[index].mp3Path;
      await _audioPlayer.value.play(AssetSource(mp3Path!));
      // await _assetsAudioPlayer.value.open(
      //   Audio('assets/${mp3Path}'),
      //   showNotification: true,
      // );

        BottomPopupPlayerController.to.isPopup(true);
        storyIndex = index;
    }
  }

  String _format(Duration d) {
    String minute =
    int.parse(d.toString().split('.').first.padLeft(8, "0").split(':')[1])
        .toString();
    String second = d.toString().split('.').first.padLeft(8, "0").split(':')[2];
    return ("$minute:$second");
  }

  //set setPositionValue(double value) => _assetsAudioPlayer.value.seek(Duration(seconds: value.toInt()));
  set setPositionValue(double value) => _audioPlayer.value.seek(Duration(seconds: value.toInt()));
  double get getDurationAsDouble => _duration.value.inSeconds.toDouble();
  String get getDurationAsFormatSting => _format(_duration.value);
  double get getPositionAsDouble => _position.value.inSeconds.toDouble();
  String get getPositionAsFormatSting => _format(_position.value);


  // void _handleInterruptions(AudioSession audioSession, String mp3Path) {
  //   // just_audio can handle interruptions for us, but we have disabled that in
  //   // order to demonstrate manual configuration.
  //   bool playInterrupted = false;
  //   audioSession.becomingNoisyEventStream.listen((_) {
  //     print('PAUSE');
  //     _audioPlayer.value.pause();
  //   });
  //   audioSession.interruptionEventStream.listen((event) {
  //     print('interruption begin: ${event.begin}');
  //     print('interruption type: ${event.type}');
  //     if (event.begin) {
  //       switch (event.type) {
  //         case AudioInterruptionType.pause:
  //         case AudioInterruptionType.unknown:
  //           if (isPlaying.value) {
  //             _audioPlayer.value.pause();
  //             playInterrupted = true;
  //           }
  //           break;
  //       }
  //     } else {
  //       switch (event.type) {
  //         case AudioInterruptionType.pause:
  //           if (playInterrupted) _audioPlayer.value.play(AssetSource(mp3Path!));
  //           playInterrupted = false;
  //           break;
  //         case AudioInterruptionType.unknown:
  //           playInterrupted = false;
  //           break;
  //       }
  //     }
  //   });
  //   audioSession.devicesChangedEventStream.listen((event) {
  //     print('Devices added: ${event.devicesAdded}');
  //     print('Devices removed: ${event.devicesRemoved}');
  //   });
  // }

}