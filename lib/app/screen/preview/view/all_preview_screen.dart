import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:enitproject/app/screen/preview/controller/preview_controller.dart';
import 'package:enitproject/app/screen/story/binding/story_binding.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/story/view/story_screen.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AllPreviewScreen extends GetView<PreviewController> {
  const AllPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: (){
                Get.back();
                //Navigator.pop(context);
              },
            ),
          ),
          title: const Text(
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
                const SizedBox(height: 20,),
                Text(
                  '전체 ${StoryService.to.storyList.length}건',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 20,),
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                          child: Text('${StoryService.to.storyList[index].addressSearch}',
                                            style: const TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              color: GREEN_DARK_COLOR,
                                            ),
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
                                            const badges.Badge(
                                              badgeStyle: BadgeStyle(
                                                badgeColor: GREEN_BRIGHT_COLOR,
                                              ),
                                              showBadge: true,
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
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                              Get.to(() => StoryScreen(storyIndex: index,), binding: StoryBinding(storyIndex: index,));
                              StoryService.to.setOpenPlay(controller.storykey(index),);
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