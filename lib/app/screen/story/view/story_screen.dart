import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/story/view/story_component/story_audio_playing_controls.dart';
import 'package:enitproject/app/screen/story/view/story_component/story_audio_position_seek.dart';
import 'package:enitproject/app/screen/user/controller/user_controller.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../bottom_popup_player/controller/bottom_popup_player_controller.dart';
import '../../bottom_popup_player/view/bottom_popup_player_screen.dart';

class StoryScreen extends GetView<StoryController> {
  final int storyIndex;

  const StoryScreen({required this.storyIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              iconSize: 35.0,
              onPressed: () {
                Get.back();
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(() => AuthService.to.userModel.value!.favorite_list
                      .contains(StoryController
                          .to.storyList[storyIndex].storyPlayListKey)
                  ?
                  /// isLike 바라보다가 변경되면 아래 부분만 변경
                  IconButton(
                      onPressed: () => {
                        UserController.to.updateUserUnFav(
                            '${StoryController.to.storyList[storyIndex].storyPlayListKey}',
                            ('${AuthService.to.userModel.value?.userKey}'))
                      },
                      icon: SvgPicture.asset(
                        'assets/icon/heart_green.svg',
                        color: GREEN_MID_COLOR,
                      ),
                    )
                  : IconButton(
                      onPressed: () => {
                            UserController.to.updateUserFav(
                                '${StoryController.to.storyList[storyIndex].storyPlayListKey}',
                                ('${AuthService.to.userModel.value?.userKey}'))
                          },
                      icon: SvgPicture.asset(
                        'assets/icon/heart_gray_line.svg',
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.zero)),
            )
          ],
        ),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
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
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${controller.storyList[storyIndex].addressDetail}',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                              child: Text(
                                '지도보기',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: GREEN_BRIGHT_COLOR,
                                ),
                              ),
                              onPressed: () {},
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Image.network(
                    '${controller.storyList[storyIndex].image}',
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  ///오디오 위치
                  controller.assetsAudioPlayer.value
                      .builderRealtimePlayingInfos(
                      builder: (context, RealtimePlayingInfos? infos) {
                        if (infos == null) {
                          return SizedBox();
                        }
                        //print('infos: $infos');
                        return Column(
                          children: [
                            ///오디오바 위젯
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

                  ///재생버튼
                  controller.assetsAudioPlayer.value.builderLoopMode(
                    builder: (context, loopMode) {
                      return PlayerBuilder.isPlaying(
                          player: controller.assetsAudioPlayer.value,
                          builder: (context, isPlaying) {
                            ///재생버튼 컨트롤 위젯
                            return PlayingControls(
                              loopMode: loopMode,
                              isPlaying: isPlaying,
                              isPlaylist: true,
                              // onStop: () {
                              //   controller.assetsAudioPlayer.value.stop();
                              // },
                              // toggleLoop: () {
                              //   controller.assetsAudioPlayer.value.toggleLoop();
                              // },
                              onPlay: () {
                                controller.assetsAudioPlayer.value
                                    .playOrPause();
                              },
                            );
                          });
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 360,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: GREEN_MID_COLOR),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 110),

                      ///글 내용
                      child: Text(
                        '${controller.storyList[storyIndex].script}',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 110,


                  ),
                ],
              ),
            ),
          ),
          Obx(() => BottomPopupPlayerController.to.isPopup.value
              ? Positioned(
                  bottom: 12,
                  left: 10,
                  right: 10,
                  child: BottomPopupPlayer(
                    storyIndex: storyIndex,
                  ))
              : SizedBox.shrink()),
        ]),
      ),
    );
  }
}
