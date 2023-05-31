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

  ///나중에 오디오 패스랑 메타 추가
  late Audio audio;

  ///싱글톤처럼 쓰기위함
  static FavoriteController get to => Get.find();

  ///데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> favStoryList = <StoryListModel>[].obs;

  ///하단팝업을 위한 bool값
  final Rx<bool> isPlaying = false.obs;


  @override
  void onInit() async{

    ///데이터 리스트에 넣어주기
    await storyListNetworkRepository.getFavStoryModel().then((value) => {
      favStoryList(value)
    });

    super.onInit();
  }

  @override
  void onReady() async{
    super.onReady();
  }

  ///관심목록 빼기
  void updateUnLike(String storyListKey, int index) async {
    ///파이어베이스에서 데이터 바꿔주기
    await storyListNetworkRepository.updateStoryListLike(storyListKey, false).then((value) async =>
    {
      ///관심목록 리스트에서 삭제해주기 _ obx작동을 위해서
      favStoryList.removeAt(index),

      ///관심목록 리스트랑 이야기 리스트랑 순서 인덱스 다르니까 키값으로 찾아서 이야기 리스트에서도 좋아요 취소해주기
      for(int i = 0; i < StoryController.to.storyList.length; i++)
        {
          if(StoryController.to.storyList[i].storyPlayListKey == storyListKey)
            {
              ///이야기 리스트에서 좋아요 취소
              StoryController.to.storyList[i].isLike = false,
              StoryController.to.storyList.refresh(),
            }
        }

    });
  }

  ///오디오 재생할 것 미리 셋팅 + 백그라운드에 보여줄 데이터 셋팅
  void setOpenPlay(int index) async {
    String? mp3Path = favStoryList[index].mp3Path;
    audio = Audio('assets/${mp3Path}',

      ///백그라운드랑 상단 바 안에 표시해줄 데이터 넣는 것
      metas: Metas(
        title:  favStoryList[index].title,
        artist: favStoryList[index].addressSearch,
        image: MetasImage.network('${favStoryList[index].image}'), //can be MetasImage.network
      ),
    );
    StoryController.to.assetsAudioPlayer.refresh();

    ///오디오 재생
    await StoryController.to.assetsAudioPlayer.value.open(
      audio,
      showNotification: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      autoStart: false,
    );

    ///하단팝업
    BottomPopupPlayerController.to.isPopup(true);
    storyIndex = index;
  }

  ///관심목록 리스트랑 이야기 리스트의 인덱스가 달라서
  ///선택된 리스트 인덱스번째의 키값과 이야기의 키값 대조해서 같은 키값을 가진 이야기리스트의 인덱스를 찾아서
  ///int 'storykey'로 뺴줌
  int storykey(int index){
    late int key;
    for(int i = 0; i < StoryController.to.storyList.length; i++)
    {
      if(favStoryList[index].storyPlayListKey == StoryController.to.storyList[i].storyPlayListKey)
      {
        key = i;
      }
    }
    return key;
  }

}