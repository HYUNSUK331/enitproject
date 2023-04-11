import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../const/color.dart';
import '../story/story_controller.dart';
import '../story/story_screen.dart';
import 'bottom_popup_player_controller.dart';

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
                  padding: EdgeInsets.fromLTRB(3, 3, 0, 3),
                  child: Obx(()=> Image.network(
                    '${controller.popupImage}', width: 100, height: 100, fit: BoxFit.contain,),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 65,
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Obx(()=> Text(
                              '${controller.popupTitle}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)
                          )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Obx(()=> Text(
                              '${controller.popupAddressDetail}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,)
                          )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() => StoryController.to.isPlaying.value?
                IconButton(
                  icon: Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  onPressed: () async{
                    StoryController.to.updatePause();
                  },
                )
                    :
                IconButton(
                  onPressed: () async{
                    StoryController.to.updatePlay(storyIndex);
                  },
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30.0,
                  ),
                )
                ),
                Obx(() => StoryController.to.storyList[storyIndex].isLike?
                IconButton(
                  onPressed: () => {
                    StoryController.to.updateUnLike('${StoryController.to.storyList[storyIndex].storyPlayListKey}', storyIndex)
                  },
                  icon: const Icon(
                    Icons.favorite,
                    size: 30.0,
                    color: GREEN_DARK_COLOR,),
                )
                    :
                IconButton(
                    onPressed: ()=>{
                      StoryController.to.updateLike('${StoryController.to.storyList[storyIndex].storyPlayListKey}',storyIndex)
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      size: 30.0,
                      color: Colors.white,),
                    padding: EdgeInsets.zero
                )
                ),
                // Obx(()=> controller.isPlay.value?
                // IconButton(onPressed: (){
                //   controller.updatePause(playlistIndex);
                // }, icon: Icon(Icons.pause, color: Colors.white, size: 30)) :
                // IconButton(
                //   onPressed: () async{
                //     controller.updatePlay(playlistIndex);
                //   },
                //   icon: Icon(Icons.play_arrow, size: 30, color: Colors.white,),
                // )),
                //
                // IconButton(onPressed: (){
                //   controller.updateStop(playlistIndex);
                // }, icon: Icon(Icons.stop, size: 35, color: Colors.white),padding: EdgeInsets.fromLTRB(0, 0, 0, 0),),
            ],
          ),
          ],
        ),
      ),
      onTap: (){
        Get.to(() => StoryScreen(storyIndex: storyIndex,));
      },
    );
  }
}