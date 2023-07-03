import 'package:enitproject/app/screen/story/binding/story_binding.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../story/controller/story_controller.dart';
import '../../story/view/story_screen.dart';
import '../controller/bottom_popup_player_controller.dart';

class BottomPopupPlayer extends GetView<BottomPopupPlayerController> {
  final int storyIndex;
  const BottomPopupPlayer({
    required this.storyIndex,
    Key? key
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity, height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: GREEN_BRIGHT_COLOR,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 70, height: 70,
                  padding: const EdgeInsets.fromLTRB(3, 3, 0, 3),
                  child: Obx(()=> Image.network(
                    '${StoryService.to.storyList[storyIndex].image}', width: 100, height: 100, fit: BoxFit.contain,),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 65,
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Obx(()=> Text(
                              '${StoryService.to.storyList[storyIndex].title}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)
                          )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Obx(()=> Text(
                              '${StoryService.to.storyList[storyIndex].addressDetail}',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,)
                          )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: (){
                      // StoryController.to.updatePlay(storyIndex);
                    },
                    icon: Obx(() => StoryService.to.isPlaying.value?
                    const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 35.0,
                    ) : const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30.0,
                    )
                    )
                ),
                Obx(() => AuthService.to.userModel.value!.favoriteList
                    .contains(StoryService
                    .to.storyList[storyIndex].storyPlayListKey)
                    ?

                /// isLike 바라보다가 변경되면 아래 부분만 변경
                IconButton(
                  onPressed: () => {
                    StoryService.to.updateUserUnFav(
                        '${StoryService.to.storyList[storyIndex].storyPlayListKey}',
                        ('${AuthService.to.userModel.value?.userKey}'))
                  },
                  icon: SvgPicture.asset(
                    'assets/icon/heart_green.svg',
                  ),
                )
                    : IconButton(
                    onPressed: () => {
                      StoryService.to.updateUserFav(
                          '${StoryService.to.storyList[storyIndex].storyPlayListKey}',
                          ('${AuthService.to.userModel.value?.userKey}'))
                    },
                    icon: SvgPicture.asset(
                      'assets/icon/heart_gray_line.svg',
                    ),
                    padding: EdgeInsets.zero)),
            ],
          ),
          ],
        ),
      ),
      onTap: (){
        Get.to(() => StoryScreen(storyIndex: storyIndex,), binding: StoryBinding(storyIndex: storyIndex,));
      },
      onTapCancel: () {
        if(StoryService.to.isPlaying.value == false) {
          controller.isPopup(false);
        }
      },
    );
  }
}