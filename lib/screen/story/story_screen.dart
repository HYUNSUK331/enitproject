import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/screen/story/story_component/story_audio_playing_controls.dart';
import 'package:enitproject/screen/story/story_component/story_audio_position_seek.dart';
import 'package:enitproject/screen/story/story_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../const/color.dart';
import '../bottom_popup_player/bottom_popup_player_controller.dart';
import '../bottom_popup_player/bottom_popup_player_screen.dart';

class StoryScreen extends GetView<StoryController> {
  final int storyIndex;
  const StoryScreen({
    required this.storyIndex,
    Key? key
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,


        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                  icon: SvgPicture.asset('assets/icon/back_black.svg',
                    color: Colors.black,
                  ),
                  iconSize: 70,
                  onPressed: (){
                    Navigator.maybePop(context);
                  },
                  ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),

                child: Obx(() => controller.storyList[storyIndex].isLike?
                IconButton(
                    onPressed: () => {
                      controller.updateUnLike('${controller.storyList[storyIndex].storyPlayListKey}', storyIndex)
                    },
                    icon: SvgPicture.asset('assets/icon/heart_green.svg',
                      color: GREEN_DARK_COLOR,
                    ),
                  iconSize: 70,
                )
                    :
                IconButton(
                    onPressed: ()=>{
                      controller.updateLike('${controller.storyList[storyIndex].storyPlayListKey}',storyIndex)
                    },
                    icon: SvgPicture.asset('assets/icon/heart_gray_line.svg',
                      color: Colors.grey,
                    ),
                  iconSize: 70,
                )
                ),
              )
            ],
          ),
        ),

        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(height: 20.0,),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            '${controller.storyList[storyIndex].title}',
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${controller.storyList[storyIndex].addressDetail}',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              TextButton(
                                child: Text(
                                  '지도보기',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: GREEN_DARK_COLOR,
                                  ),
                                ),
                                onPressed: (){},
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    Image.network(
                      '${controller.storyList[storyIndex].image}',
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 15.0,),
                    controller.assetsAudioPlayer.value.builderRealtimePlayingInfos(
                        builder: (context, RealtimePlayingInfos? infos) {
                          if (infos == null) {
                            return SizedBox();
                          }
                          //print('infos: $infos');
                          return Column(
                            children: [
                              PositionSeekWidget(
                                currentPosition: infos.currentPosition,
                                duration: infos.duration,
                                seekTo: (to) {
                                  controller.assetsAudioPlayer.value.seek(to);
                                },
                              ),
                            ],
                          );
                        }),
                    controller.assetsAudioPlayer.value.builderLoopMode(
                      builder: (context, loopMode) {
                        return PlayerBuilder.isPlaying(
                            player: controller.assetsAudioPlayer.value,
                            builder: (context, isPlaying) {
                              return PlayingControls(
                                loopMode: loopMode,
                                isPlaying: isPlaying,
                                isPlaylist: true,
                                onStop: () {
                                  controller.assetsAudioPlayer.value.stop();
                                },
                                toggleLoop: () {
                                  controller.assetsAudioPlayer.value.toggleLoop();
                                },
                                onPlay: () {
                                  controller.assetsAudioPlayer.value.playOrPause();
                                },
                              );
                            });
                      },
                    ),
                    SizedBox(height: 20.0,),
                    Container(
                      child: Text(
                        '${controller.storyList[storyIndex].script}',
                        style: TextStyle(
                            fontSize: 15.0
                        ),
                      ),
                    ),
                    SizedBox(height: 110,),
                  ],
                ),
              ),
            ),
            Obx(()=> BottomPopupPlayerController.to.isPopup.value?
            Positioned(
                bottom: 12, left: 10, right: 10,
                child: BottomPopupPlayer(storyIndex: storyIndex,)
            ) :
            SizedBox.shrink()),
          ]
        ),
      ),
    );
  }
}
