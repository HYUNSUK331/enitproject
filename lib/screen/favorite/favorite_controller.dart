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
import '../story/story_controller.dart';

class FavoriteController extends GetxController{

  late String storyIDkey;
  late Audio audio;

  //싱글톤처럼 쓰기위함
  static FavoriteController get to => Get.find();

  //데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> favStoryList = <StoryListModel>[].obs;


  final Rx<bool> isPlaying = false.obs;



  @override
  void onInit() async{
    await storyListNetworkRepository.getFavStoryModel().then((value) => {
      favStoryList(value)
    });

    super.onInit();
  }

  @override
  void onReady() async{
    super.onReady();
  }

  void changeTrueBadgeColor(int index) {
    favStoryList[index].changeStoryColor = GREEN_BRIGHT_COLOR;
  }

  void changeFalseBadgeColor(int index) {
    favStoryList[index].changeStoryColor = LIGHT_YELLOW_COLOR;
  }

  void updateLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, true).then((value) async =>
    {
      favStoryList[index].isLike = true,
      favStoryList.refresh(),
    });
  }
  void updateUnLike(String storyListKey, int index) async {
    await storyListNetworkRepository.updateStoryListLike(storyListKey, false).then((value) async =>
    {
      favStoryList[index].isLike = false,
      favStoryList.refresh(),
    });
  }

  void setOpenPlay(int index) async {
    String? mp3Path = favStoryList[index].mp3Path;
    audio = Audio('assets/${mp3Path}',
      metas: Metas(
        title:  favStoryList[index].title,
        artist: favStoryList[index].addressSearch,
        image: MetasImage.network('${favStoryList[index].image}'), //can be MetasImage.network
      ),
    );
    StoryController.to.assetsAudioPlayer.refresh();
    await StoryController.to.assetsAudioPlayer.value.open(
      audio,
      showNotification: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      autoStart: false,
    );

    BottomPopupPlayerController.to.isPopup(true);
    storyIndex = index;
  }


}