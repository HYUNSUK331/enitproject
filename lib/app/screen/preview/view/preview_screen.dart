import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:enitproject/app/screen/preview/controller/preview_controller.dart';
import 'package:enitproject/app/screen/story/binding/story_binding.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/story/view/story_screen.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PreviewScreen extends GetView<PreviewController> {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const Text(
            '둘러보기',
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
              Row(
                children: [
                  const Text(
                    '전체',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Text('${StoryService.to.storyList.length}',
                    style: const TextStyle(
                        color: FONT_MID_BLACK_COLOR,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0
                    ),)
                ],
              ),
              const Divider(height: 5,),
              const SizedBox(height: 30,),
              Expanded(
                child: ListView.builder(
                    itemCount: StoryService.to.storyList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: SizedBox(
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
                                    '${StoryService.to.storyList[index].image}',
                                    width: 100, height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${StoryService.to.storyList[index].addressSearch}',
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            color: GREEN_DARK_COLOR,
                                          ),
                                        ),
                                      const SizedBox(height: 10.0,),
                                      Row(
                                        children: [
                                          Text(
                                            '${StoryService.to.storyList[index].title}',
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          const SizedBox(width: 5.0,),
                                          Obx(() =>
                                          AuthService.to.userModel.value!.circleList.contains(StoryService.to.storyList[index].storyPlayListKey) ?
                                          const badges.Badge(
                                            badgeStyle: BadgeStyle(
                                              badgeColor: GREEN_BRIGHT_COLOR,
                                            ),
                                            showBadge: true,
                                          )
                                              :
                                          const badges.Badge(
                                            badgeStyle: BadgeStyle(
                                              badgeColor: LIGHT_YELLOW_COLOR,
                                            ),
                                            showBadge: true,
                                          ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10.0,),
                                      Text(
                                        '${StoryService.to.storyList[index].addressDetail}',
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                /// 헤드셋 나오게하는 버튼
                                // Obx(() => StoryService.to.storyList[index].changeStoryColor == GREEN_BRIGHT_COLOR?
                                //   IconButton(
                                //     onPressed: () async{
                                //       // StoryController.to.updatePlay(index);
                                //     },
                                //     icon: Obx(() => StoryService.to.isPlaying.value?
                                //      const Icon(
                                //       Icons.headphones,
                                //       color: GREEN_MID_COLOR,
                                //    )
                                //       :
                                //       const Icon(
                                //         Icons.headphones,
                                //         color: GREEN_MID_COLOR,
                                //     )
                                //     ),
                                // )
                                //     :
                                //   const SizedBox.shrink(),
                                // ),
                                /// 좋아요 기능
                                Obx(() => AuthService.to.userModel.value!.favoriteList.contains(StoryService.to.storyList[index].storyPlayListKey)?  /// isLike 바라보다가 변경되면 아래 부분만 변경
                                  IconButton(
                                    onPressed: () => {
                                      StoryService.to.updateUserUnFav('${StoryService.to.storyList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
                                    },
                                    icon: SvgPicture.asset('assets/icon/heart_green.svg',color: GREEN_MID_COLOR,),
                                )
                                    :
                                  IconButton(
                                    onPressed: ()=>{
                                      StoryService.to.updateUserFav('${StoryService.to.storyList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
                                    },
                                    icon: SvgPicture.asset('assets/icon/heart_gray_line.svg',color: Colors.grey),
                                    padding: EdgeInsets.zero
                                )
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if(AuthService.to.userModel.value!.circleList.contains(StoryService.to.storyList[index].storyPlayListKey)) {
                            Get.to(() => StoryScreen(storyIndex: index,), binding: StoryBinding(storyIndex: index,));
                            StoryService.to.setOpenPlay(controller.storykey(index),);
                          }
                        },
                      );
                    }
                ),
              ),
              Obx(() => BottomPopupPlayerController.to.isPopup.value?
                const SizedBox(height: 90,) : const SizedBox.shrink()
              )
            ],
          ),
        ),

    );
  }

}