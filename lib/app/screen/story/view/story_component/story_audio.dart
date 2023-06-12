import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/story/view/story_component/story_audio_playing_controls.dart';
import 'package:enitproject/app/screen/story/view/story_component/story_audio_position_seek.dart';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class StoryAudio extends GetView<StoryController>{
  final int storyIndex;
  const StoryAudio({
    required this.storyIndex,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}