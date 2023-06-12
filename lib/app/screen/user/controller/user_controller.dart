import 'package:enitproject/model/user_model.dart';
import 'package:enitproject/repository/user_repository.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class UserController extends GetxController {

  //싱글톤처럼 쓰기위함
  static UserController get to => Get.find();

  @override
  void onInit() async{  // favStoryList에 DB에서 받아온 list 넣어주기 / 로컬에서 핸들링
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







  /// user fav update 하기
  void updateUserFav(String storyListKey, String userKey) async {
    if(AuthService.to.userModel.value != null){
      AuthService.to.userModel.value?.favorite_list.add(storyListKey.toString());
      AuthService.to.userModel.refresh();
    }
    await userRepository.updateFavList(AuthService.to.userModel.value?.favorite_list,userKey);
  }
  /// user unfav update 하기
  void updateUserUnFav(String storyListKey, String userKey2) async {
    if(AuthService.to.userModel.value != null){
      AuthService.to.userModel.value?.favorite_list.remove(storyListKey.toString());
      AuthService.to.userModel.refresh();
    }
    await userRepository.updateFavList(AuthService.to.userModel.value?.favorite_list,userKey2);
  }



}