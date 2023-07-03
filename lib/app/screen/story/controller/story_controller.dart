import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:enitproject/app/screen/favorite_list/controller/favorite_controller.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/const/const.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/repository/storylist_network_repository.dart';
import 'package:enitproject/repository/user_repository.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:get/get.dart';


class StoryService extends GetxService{
  ///싱글톤처럼 쓰기위함
  static StoryService get to => Get.find();
  ///나중에 오디오 패스랑 메타 추가
  late Audio audio;

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
    audio = Audio.network(
        mp3Path!,

        ///백그라운드랑 상단 바 안에 표시해줄 데이터 넣는 것
        metas: Metas(
          title:  storyList[index].title,
          artist: storyList[index].addressSearch,
          image: MetasImage.network('${storyList[index].image}'),
        )
    );
    assetsAudioPlayer.refresh();

    ///오디오 재생
    await assetsAudioPlayer.value.open(
      audio,
      showNotification: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      autoStart: false,
    );


    ///하단팝업 일단 정지
    // BottomPopupPlayerController.to.isPopup(true);
    // storyIndex = index;
  }

  void updateUserFav(String storyListKey, String userKey) async {
    if(AuthService.to.userModel.value != null){
      AuthService.to.userModel.value?.favoriteList.add(storyListKey.toString());
      AuthService.to.userModel.refresh();
    }
    await userRepository.updateFavList(AuthService.to.userModel.value?.favoriteList,userKey);
  }

  /// user unfav update 하기
  void updateUserUnFav(String storyListKey, String userKey2) async {
    if(AuthService.to.userModel.value != null){
      AuthService.to.userModel.value?.favoriteList.remove(storyListKey.toString());
      AuthService.to.userModel.refresh();
    }
    await userRepository.updateFavList(AuthService.to.userModel.value?.favoriteList,userKey2);
  }


}