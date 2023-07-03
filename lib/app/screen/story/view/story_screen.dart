import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/story/view/story_component/story_audio_playing_controls.dart';
import 'package:enitproject/app/screen/story/view/story_component/story_audio_position_seek.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoryScreen extends GetView<StoryService> {
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
              icon: const Icon(Icons.arrow_back_ios),
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
              child: Obx(() => AuthService.to.userModel.value!.favoriteList
                      .contains(StoryService
                          .to.storyList[storyIndex].storyPlayListKey)
                  ?
                  /// favorite_list 바라보다가 변경되면 아래 부분만 변경
                  IconButton(
                      onPressed: () => {
                        StoryService.to.updateUserUnFav(
                            '${StoryService.to.storyList[storyIndex].storyPlayListKey}',
                            ('${AuthService.to.userModel.value?.userKey}'))
                      },
                      icon: SvgPicture.asset(
                        'assets/icon/heart_green.svg',color: GREEN_MID_COLOR
                      ),
                    )
                  : IconButton(
                      onPressed: () => {
                        StoryService.to.updateUserFav(
                                '${StoryService.to.storyList[storyIndex].storyPlayListKey}',
                                ('${AuthService.to.userModel.value?.userKey}'))
                          },
                      icon: SvgPicture.asset(
                        'assets/icon/heart_gray_line.svg',color: GREEN_MID_COLOR,
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
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '${controller.storyList[storyIndex].title}',
                          style: const TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${controller.storyList[storyIndex].addressDetail}',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                              child: const Text(
                                '지도로 돌아가기',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: GREEN_BRIGHT_COLOR,
                                ),
                              ),
                              onPressed: () {
                                Get.rootDelegate.offAndToNamed(Routes.HOME);
                                MapHomeController.to.mapController!.animateCamera(
                                  CameraUpdate.newLatLng( // story 클릭 시 그 위치로 이동시키기
                                    LatLng(controller.storyList[storyIndex].latitude!.toDouble(), controller.storyList[storyIndex].longitude!.toDouble()
                                    ),
                                  ),
                                );
                                Get.back();
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      '${controller.storyList[storyIndex].image}',
                      width: double.infinity,
                      fit: BoxFit.contain,

                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),

                  ///오디오 위치
                  controller.assetsAudioPlayer.value
                      .builderRealtimePlayingInfos(
                      builder: (context, RealtimePlayingInfos? infos) {
                        if (infos == null) {
                          return const SizedBox();
                        }
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
                              isPlaylist: false,
                              // onStop: () {
                              //   controller.assetsAudioPlayer.value.stop();
                              // },
                              // toggleLoop: () {
                              //   controller.assetsAudioPlayer.value.toggleLoop();
                              // },
                              onPlay: () {
                                controller.assetsAudioPlayer.value
                                    .playOrPause();
                                print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$isPlaying");
                              },

                            );
                          });
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 360,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: GREEN_MID_COLOR),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 110),

                      ///글 내용
                      child: Text(
                        '${controller.storyList[storyIndex].script}',
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 110,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
