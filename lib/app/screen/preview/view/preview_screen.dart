import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:enitproject/app/screen/preview/controller/preview_controller.dart';
import 'package:enitproject/app/screen/story/binding/story_binding.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/story/view/story_screen.dart';
import 'package:enitproject/app/screen/user/controller/user_controller.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class PreviewScreen extends GetView<PreviewController> {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: (){
              //Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          '둘러보기 or 검색지역 이름',
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 15.0
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Text(
              '전체 ${StoryController.to.storyList.length}건',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(
                  itemCount: StoryController.to.storyList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Container(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  '${StoryController.to.storyList[index].image}',
                                  width: 100, height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                      child: Text('${StoryController.to.storyList[index].addressSearch}',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: GREEN_DARK_COLOR,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.0,),
                                    Row(
                                      children: [
                                        Text(
                                          '${StoryController.to.storyList[index].title}',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        SizedBox(width: 5.0,),
                                        // Obx(() => controller.storyList[index].changeStoryColor == GREEN_BRIGHT_COLOR?
                                        //   Badge(
                                        //     badgeStyle: BadgeStyle(
                                        //       badgeColor: GREEN_BRIGHT_COLOR,
                                        //     ),
                                        //     showBadge: true,
                                        //   )
                                        //     :
                                        // Badge(
                                        //   badgeStyle: BadgeStyle(
                                        //     badgeColor: LIGHT_YELLOW_COLOR,
                                        //   ),
                                        //   showBadge: true,
                                        // ),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(height: 10.0,),
                                    Text(
                                      '${StoryController.to.storyList[index].addressDetail}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 5,),
                              Obx(() => StoryController.to.storyList[index].changeStoryColor == GREEN_BRIGHT_COLOR?
                                IconButton(
                                  onPressed: () async{
                                    // StoryController.to.updatePlay(index);
                                  },
                                  icon: Obx(() => StoryController.to.isPlaying.value?
                                   Icon(
                                    Icons.headphones,
                                    color: GREEN_MID_COLOR,
                                 )
                                    :
                                    Icon(
                                      Icons.headphones,
                                      color: GREEN_MID_COLOR,
                                  )
                                  ),
                              )
                                  :
                                SizedBox.shrink(),
                              ),
                              /// 좋아요 기능
                              Obx(() => AuthService.to.userModel.value!.favorite_list.contains(StoryController.to.storyList[index].storyPlayListKey)?  /// isLike 바라보다가 변경되면 아래 부분만 변경
                                IconButton(
                                  onPressed: () => {
                                    UserController.to.updateUserUnFav('${StoryController.to.storyList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
                                  },
                                  icon: SvgPicture.asset('assets/icon/heart_green.svg',
                                    color: GREEN_MID_COLOR,),
                              )
                                  :
                                IconButton(
                                  onPressed: ()=>{
                                    UserController.to.updateUserFav('${StoryController.to.storyList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
                                  },
                                  icon: SvgPicture.asset('assets/icon/heart_gray_line.svg',
                                    color: Colors.grey,),
                                  padding: EdgeInsets.zero
                              )
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        if(MapHomeController.to.latLngList[index].circleColor == false) {
                          Get.to(() => StoryScreen(storyIndex: index,), binding: StoryBinding(storyIndex: index,));
                        }
                      },
                    );
                  }
              ),
            ),
            Obx(() => BottomPopupPlayerController.to.isPopup.value?
            SizedBox(height: 90,) : SizedBox.shrink()
            )
          ],
        ),
      ),

    );
  }

}