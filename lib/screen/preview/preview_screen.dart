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

class PreviewScreen extends GetView<StoryController> {
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
            icon: SvgPicture.asset('assets/icon/back_black.svg'),
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
              '전체 ${controller.storyList.length}건',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(
                  itemCount: controller.storyList.length,
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
                                  '${controller.storyList[index].image}',
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
                                      child: Text('${controller.storyList[index].addressSearch}',
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
                                          '${controller.storyList[index].title}',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        SizedBox(width: 5.0,),
                                        Obx(() => controller.storyList[index].changeStoryColor == GREEN_BRIGHT_COLOR?
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
                                    SizedBox(height: 10.0,),
                                    Text(
                                      '${controller.storyList[index].addressDetail}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 5,),
                              Obx(() => controller.storyList[index].isLike?
                                IconButton(
                                  onPressed: () => {
                                    controller.updateUnLike('${controller.storyList[index].storyPlayListKey}', index)
                                  },
                                  icon: SvgPicture.asset('assets/icon/heart_green.svg',
                                    color: GREEN_DARK_COLOR,),
                              )
                                  :
                                IconButton(
                                  onPressed: ()=>{
                                    controller.updateLike('${controller.storyList[index].storyPlayListKey}',index)
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
                        if(controller.storyList[index].changeStoryColor == GREEN_BRIGHT_COLOR)
                        {
                          Get.to(() => StoryScreen(storyIndex: index,));
                          controller.setOpenPlay(index);
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