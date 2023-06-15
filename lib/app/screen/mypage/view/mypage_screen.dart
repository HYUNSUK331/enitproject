import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/favorite_list/controller/favorite_controller.dart';
import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MYPAGE"),),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              AuthService.to.logout();

              Get.rootDelegate.offAndToNamed(Routes.LOGIN);

              // Get.put(LoginController());  // 이거랑 밑에꺼 없었는데 로그아웃하고 페이지를 벗어나지 못했다.
              // Get.off(()=>const LoginView());  //offall을 사용하면 에러... 왜 인지는 아직 모르겠음 getall 은 모든 페이지 삭제 하는건데 여기서 화면 전환이 안된다
              // );
            },
            child: Text("LOGOUT"),
          ),
          Text('${StoryService.to.storyList[0].storyPlayListKey}'),
          Text('${AuthService.to.userModel.value?.userKey}'),
          Text("2222222222222222222222222favorite_list"),
          Text('${AuthService.to.userModel.value?.favorite_list}'),
          Text('${StoryService.to.storyList}'),
          Text("2222222222222222222222222"),
          Text('${FavoriteController.to.favStoryList.length}'),
          Text("2222222222222222222222222"),
          Text("${MapHomeController.to.latLngList.length}"),  ///11
          Text("${MapHomeController.to.latLngList}"),  /// StoryController.to.storyList 이거랑 똑같음....
          Text("333333333333333333333333333333circle_list"),
          Text('${AuthService.to.userModel.value?.circle_list}'),
          Text("333333333333333333333333333333circle_color"),
          Text("${MapHomeController.to.invisibleTableRowSwitchList1}"),
          Text("${MapHomeController.to.allowPermissionStr}"),
          // Text('${FavoriteController.to.favStoryList[0].storyPlayListKey}'),
          // Text('${FavoriteController.to.favStoryList[1].storyPlayListKey}'),
          // Text('${FavoriteController.to.favStoryList[2].storyPlayListKey}'),
          // Text('${FavoriteController.to.favStoryList[3].storyPlayListKey}'),
          // Text('${FavoriteController.to.favStoryList[4].storyPlayListKey}'),

          //Text('${StoryController.to.storyList}'),
        ],
      ),
    );
  }
}
