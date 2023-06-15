import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/const/const.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/repository/storylist_network_repository.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FavoriteController extends GetxController {
  ///나중에 오디오 패스랑 메타 추가
  late Audio audio;

  ///싱글톤처럼 쓰기위함
  static FavoriteController get to => Get.find();

  ///데이터베이스에 있는 정보 가져와서 담을 리스트 선언
  RxList<StoryListModel> favStoryList = <StoryListModel>[].obs;

  ///하단팝업을 위한 bool값
  final Rx<bool> isPlaying = false.obs;

  @override
  void onInit() async {
    ///데이터 리스트에 넣어주기
    loadMore2();

    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  /// 질문2.
  /// 데이터 가져올때 전부 가져오는게 비용이 많이 발생하는지?
  /// DB에서 원하는 데이터 탖아서 가져오는게 많이 들지
  loadMore() async {
    await storyListNetworkRepository
        .getFavStoryModel()
        .then((value) => {favStoryList(value)});
  }



  /// 여기서 로컬에잇는 유저와 storylist를 통해 좋아요 표시된 친구들만 가져온다.
  loadMore2() async {
    favStoryList.clear();
      for (int j = 0; j < StoryService.to.storyList.length; j++) {
        if (AuthService.to.userModel.value!.favorite_list.contains(StoryService.to.storyList[j].storyPlayListKey)
        ) {
              print("222222222222222222222222222222222222222222222222222222222222222222222222222222222222");
              favStoryList.add(StoryService.to.storyList[j]);
              favStoryList.refresh();
            }
      }
    }

    ///관심목록 빼기
    void updateUnLike(String storyListKey, int index) async {
      ///파이어베이스에서 데이터 바꿔주기
      await storyListNetworkRepository
          .updateStoryListLike(storyListKey, false)
          .then((value) async =>
      {
        ///관심목록 리스트에서 삭제해주기 _ obx작동을 위해서
        favStoryList.removeAt(index),

        ///관심목록 리스트랑 이야기 리스트랑 순서 인덱스 다르니까 키값으로 찾아서 이야기 리스트에서도 좋아요 취소해주기
        for (int i = 0; i < StoryService.to.storyList.length; i++)
          {
            if (StoryService.to.storyList[i].storyPlayListKey ==
                storyListKey)
              {
                ///이야기 리스트에서 좋아요 취소
                StoryService.to.storyList[i].isLike = false,
                StoryService.to.storyList.refresh(),
              }
          }
      });
    }

    ///오디오 재생할 것 미리 셋팅 + 백그라운드에 보여줄 데이터 셋팅
    void setOpenPlay(int index) async {
      String? mp3Path = favStoryList[index].mp3Path;
      audio = Audio(
        'assets/${mp3Path}',

        ///백그라운드랑 상단 바 안에 표시해줄 데이터 넣는 것
        metas: Metas(
          title: favStoryList[index].title,
          artist: favStoryList[index].addressSearch,
          image: MetasImage.network(
              '${favStoryList[index].image}'), //can be MetasImage.network
        ),
      );
      StoryService.to.assetsAudioPlayer.refresh();

      ///오디오 재생
      await StoryService.to.assetsAudioPlayer.value.open(
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
    int storykey(int index) {
      late int key;
      for (int i = 0; i < StoryService.to.storyList.length; i++) {
        if (favStoryList[index].storyPlayListKey ==
            StoryService.to.storyList[i].storyPlayListKey) {
          key = i;
        }
      }
      return key;
    }
  }
