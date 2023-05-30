import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/model/user_model.dart';
import 'package:enitproject/repository/story_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FavoriteListController extends GetxController{

  //싱글톤처럼 쓰기위함
  static FavoriteListController get to => Get.find();

  RxList<StoryListModel> favStoryList = RxList<StoryListModel>();  // 모든 storylist
  RxList<UserModel> userList = RxList<UserModel>();

  @override
  void onInit() async{  // favStoryList에 DB에서 받아온 list 넣어주기 / 로컬에서 핸들링
    await storyRepository.getFavStoryListListModel().then((value) => {
      favStoryList(value)
    });
    super.onInit();
  }

  @override
  void onReady() async{
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }




}