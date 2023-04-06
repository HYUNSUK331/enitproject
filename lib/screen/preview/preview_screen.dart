import 'package:badges/badges.dart';
import 'package:enitproject/screen/preview/preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../const/color.dart';
import '../story/story_screen.dart';

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
            iconSize: 35.0,
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
              '전체 ${controller.previewStoryList.length}건',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(
                  itemCount: controller.previewStoryList.length,
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
                              Image.network(
                                '${controller.previewStoryList[index].image}',
                                height: double.infinity,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${controller.previewStoryList[index].title}',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        SizedBox(width: 5.0,),
                                        Obx(() => controller.previewStoryList[index].changeStoryColor?
                                          Badge(
                                            badgeStyle: BadgeStyle(
                                              badgeColor: GREEN_BRIGHT_COLOR,
                                            ),
                                            showBadge: true,
                                          )
                                            :
                                        Badge(
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
                                      '${controller.previewStoryList[index].addressDetail}',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Obx(() => controller.previewStoryList[index].changeStoryColor?
                                Obx(() => controller.isPlaying.value?
                                  IconButton(
                                      onPressed: () async{
                                        controller.updatePause();
                                      },
                                      icon: Icon(
                                        Icons.headphones,
                                        color: GREEN_MIDDLE_COLOR,
                                      ),
                                  ):
                                IconButton(
                                  onPressed: () async{
                                    controller.updatePlay(index);
                                  },
                                  icon: Icon(
                                    Icons.headphones,
                                    color: GREEN_MIDDLE_COLOR,
                                  ),
                                ),
                                )
                                  :
                                SizedBox.shrink(),
                              ),
                              Obx(() => controller.previewStoryList[index].isLike?
                              IconButton(
                                  onPressed: () => {
                                    controller.updateUnLike('${controller.previewStoryList[index].storyPlayListKey}', index)
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: GREEN_DARK_COLOR,),
                              )
                                  :
                              IconButton(
                                  onPressed: ()=>{
                                    controller.updateLike('${controller.previewStoryList[index].storyPlayListKey}',index)
                                  },
                                  icon: const Icon(
                                    Icons.favorite_border,
                                    color: Colors.grey,),
                                  padding: EdgeInsets.zero
                              )
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Get.to(() => StoryScreen(storyIndex: index,));
                      },
                    );
                  }
              ),
            )
          ],
        ),
      ),

    );
  }

}