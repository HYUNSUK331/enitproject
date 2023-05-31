import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../const/color.dart';
import '../../const/const.dart';
import '../../service/storylist_network_repository.dart';
import '../bottom_popup_player/bottom_popup_player_controller.dart';
import '../favorite/favorite_controller.dart';

class StoryController extends GetxController{

  ///나중에 오디오 패스랑 메타 추가
  late Audio audio;

  ///싱글톤처럼 쓰기위함
  static StoryController get to => Get.find();

  ///데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> storyList = <StoryListModel>[].obs;
  
 ///오디오 플레이어
  late Rx<AssetsAudioPlayer> assetsAudioPlayer = AssetsAudioPlayer().obs;

  ///하단팝업을 위한 bool값
  final Rx<bool> isPlaying = false.obs;


  @override
  void onInit() async{

    ///데이터 리스트에 넣어주기
    await storyListNetworkRepository.getStoryListModel().then((value) => {
      storyList(value)
    });

    ///오디오 열기
    assetsAudioPlayer.value = AssetsAudioPlayer.newPlayer();

    super.onInit();
  }

  @override
  void onReady() async{
    super.onReady();
  }

  ///뱃지색 초록으로 바꾸기
  void changeTrueBadgeColor(int index) {
    storyList[index].changeStoryColor = GREEN_BRIGHT_COLOR;
  }

  ///뱃지색 노랑으로 바꾸기
  void changeFalseBadgeColor(int index) {
    storyList[index].changeStoryColor = LIGHT_YELLOW_COLOR;
  }

  ///관심목록 더하기
  void updateLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, true).then((value) async =>
    {
      storyList[index].isLike = true,
      storyList.refresh(),
      FavoriteController.to.favStoryList.add(storyList[index]),
      FavoriteController.to.favStoryList.refresh(),
    });
  }

  ///관심목록 빼기
  void updateUnLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, false).then((value) async =>
    {
      storyList[index].isLike = false,
      storyList.refresh(),

      FavoriteController.to.favStoryList.remove(storyList[index]),
      FavoriteController.to.favStoryList.refresh(),
    });
  }

  ///오디오 재생할 것 미리 셋팅 + 백그라운드에 보여줄 데이터 셋팅
  void setOpenPlay(int index) async {
    String? mp3Path = storyList[index].mp3Path;
    audio = Audio('assets/${mp3Path}',

      ///백그라운드랑 상단 바 안에 표시해줄 데이터 넣는 것
      metas: Metas(
        title:  storyList[index].title,
        artist: storyList[index].addressSearch,
        image: MetasImage.network('${storyList[index].image}'), //can be MetasImage.network
      ),

    );
    assetsAudioPlayer.refresh();

    ///오디오 재생
    await assetsAudioPlayer.value.open(
      audio,
      showNotification: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      autoStart: false,
    );

    ///하단팝업
    BottomPopupPlayerController.to.isPopup(true);
    storyIndex = index;
  }


}