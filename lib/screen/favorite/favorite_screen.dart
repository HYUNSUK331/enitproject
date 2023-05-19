import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:enitproject/screen/bottom_popup_player/bottom_popup_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../const/color.dart';
import '../story/story_controller.dart';
import '../story/story_screen.dart';
import 'favorite_controller.dart';

class FavoriteScreen extends GetView<FavoriteController> {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return SafeArea(
      top: true,

      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 15.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Row(
                children: [
                  SvgPicture.asset('assets/icon/heart_green.svg',
                    color: GREEN_MID_COLOR, width: 65, height: 65,
                  ),
                  SizedBox(width: 15,),
                  Text(
                    'LIKE',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 65
                    ),
                  ),
                  SizedBox(width: 15,),
                  Text('${controller.favStoryList.length}',
                    style: TextStyle(
                        color: FONT_MID_BLACK_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 65
                    ),)
                ],
              ),
              SizedBox(height: 50,),

              Expanded(
                child: ListView.builder(
                    itemCount: controller.favStoryList.length,
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
                                    '${controller.favStoryList[index].image}',
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
                                      Text('${controller.favStoryList[index].addressSearch}',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: GREEN_DARK_COLOR,
                                        ),
                                      ),
                                      SizedBox(height: 10.0,),
                                      Row(
                                        children: [
                                          Text(
                                            '${controller.favStoryList[index].title}',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                          SizedBox(width: 5.0,),
                                          Obx(() => controller.favStoryList[index].changeStoryColor == GREEN_BRIGHT_COLOR?
                                          badges.Badge(
                                              badgeStyle: BadgeStyle(
                                                badgeColor: GREEN_BRIGHT_COLOR,
                                              ),
                                              showBadge: true,
                                            )
                                              :
                                          badges.Badge(
                                            badgeStyle: BadgeStyle(
                                              badgeColor: LIGHT_YELLOW_COLOR,
                                            ),
                                            showBadge: true,
                                          ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text(
                                        '${controller.favStoryList[index].addressDetail}',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Obx(() => controller.favStoryList[index].isLike?
                                  IconButton(
                                    onPressed: () => {
                                      controller.updateUnLike('${controller.favStoryList[index].storyPlayListKey}', index)
                                    },
                                    icon: SvgPicture.asset('assets/icon/heart_green.svg',
                                      color: GREEN_MID_COLOR,),
                                )
                                    :
                                  IconButton(
                                    onPressed: ()=>{
                                      controller.updateLike('${controller.favStoryList[index].storyPlayListKey}',index)
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
                          late int storykey;
                          if(controller.favStoryList[index].changeStoryColor == GREEN_BRIGHT_COLOR)
                          {
                            for(int i = 0; i < controller.favStoryList.length; i++)
                              {
                                for(int j = 0; j < StoryController.to.storyList.length; j++)
                                  {
                                    if(controller.favStoryList[i].storyPlayListKey == StoryController.to.storyList[j].storyPlayListKey)
                                      {
                                        storykey = j;
                                      }
                                  }
                              }
                            Get.to(() => StoryScreen(storyIndex: storykey,),);
                            StoryController.to.setOpenPlay(storykey);
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

      ),
    );
  }

}