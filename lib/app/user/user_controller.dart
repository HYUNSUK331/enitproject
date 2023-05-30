import 'package:enitproject/model/user_model.dart';
import 'package:enitproject/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class UserController extends GetxController {

  //싱글톤처럼 쓰기위함
  static UserController get to => Get.find();

  RxList<UserModel> userList = RxList<UserModel>();


  @override
  void onInit() async{  // favStoryList에 DB에서 받아온 list 넣어주기 / 로컬에서 핸들링
    await userRepository.getUserListModel().then((value) => {
      userList(value)
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



  // user fav update 하기
  void updateUserFav(String storyListKey, int index) async {
    await userRepository.updateFavList(storyListKey).then((value) async =>
    {
      userList[index].favoritelist = storyListKey,
      userList.refresh(),
    });
  }



}