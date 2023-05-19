import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../const/color.dart';
import '../story/story_component/story_audio_playing_controls.dart';
import '../story/story_controller.dart';
import '../story/story_screen.dart';
import 'bottom_popup_player_controller.dart';
import 'bottom_popup_playing_controls.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 70, height: 70,
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Obx(()=> Image.network(
                      '${StoryController.to.storyList[storyIndex].image}', width: 100, height: 100, fit: BoxFit.contain,),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 65,
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Obx(()=> Text(
                                '${StoryController.to.storyList[storyIndex].title}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)
                            )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            child: Obx(()=> Text(
                                '${StoryController.to.storyList[storyIndex].addressDetail}',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,)
                            )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  StoryController.to.assetsAudioPlayer.value.builderLoopMode(
                    builder: (context, loopMode) {
                      return PlayerBuilder.isPlaying(
                          player: StoryController.to.assetsAudioPlayer.value,
                          builder: (context, isPlaying) {
                            return BottomPopupPlayingControls(
                              loopMode: loopMode,
                              isPlaying: isPlaying,
                              isPlaylist: true,
                              onStop: () {
                                StoryController.to.assetsAudioPlayer.value.stop();
                              },
                              onPlay: () {
                                StoryController.to.assetsAudioPlayer.value.playOrPause();
                              },
                            );
                          });
                    },
                  ),
                  Obx(() => StoryController.to.storyList[storyIndex].isLike?
                  IconButton(
                    onPressed: () => {
                      StoryController.to.updateUnLike('${StoryController.to.storyList[storyIndex].storyPlayListKey}', storyIndex)
                    },
                    icon: SvgPicture.asset('assets/icon/heart_black.svg',
                      color: Colors.white,),
                  )
                      :
                  IconButton(
                      onPressed: ()=>{
                        StoryController.to.updateLike('${StoryController.to.storyList[storyIndex].storyPlayListKey}',storyIndex)
                      },
                      icon: SvgPicture.asset('assets/icon/heart_white_line.svg',
                        color: Colors.white,),
                      padding: EdgeInsets.zero
                  )
                  ),
              ],
          ),
            ),
          ],
        ),
      ),
      onTap: (){
        Get.to(() => StoryScreen(storyIndex: storyIndex,));
      },
      onTapCancel: () {
        if(StoryController.to.isPlaying.value == false)
        controller.isPopup(false);
      },
    );
  }
}