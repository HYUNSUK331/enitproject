import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/const/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';


class PlayingControls extends GetView<StoryService> {
  final bool isPlaying;
  final LoopMode? loopMode;
  final bool isPlaylist;
  final Function()? onPrevious;
  final Function() onPlay;
  final Function()? onNext;
  final Function()? toggleLoop;
  final Function()? onStop;

  ///근데 이것도 예시 가져다 복붙해서 왜 이렇게 해야하는지는 모르겠음...
  PlayingControls({
    required this.isPlaying,
    this.isPlaylist = false,
    this.loopMode,
    this.toggleLoop,
    this.onPrevious,
    required this.onPlay,
    this.onNext,
    this.onStop,
  });

  // Widget _loopIcon(BuildContext context) {
  //   final iconSize = 34.0;
  //   if (loopMode == LoopMode.none) {
  //     return Icon(
  //       Icons.loop,
  //       size: iconSize,
  //       color: Colors.grey,
  //     );
  //   } else if (loopMode == LoopMode.playlist) {
  //     return Icon(
  //       Icons.loop,
  //       size: iconSize,
  //       color: Colors.black,
  //     );
  //   } else {
  //     //single
  //     return Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         Icon(
  //           Icons.loop,
  //           size: iconSize,
  //           color: Colors.black,
  //         ),
  //         Center(
  //           child: Text(
  //             '1',
  //             style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ],
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        ///play or pause 버튼
        IconButton(
          onPressed: onPlay,
          icon:
          isPlaying
              ? SvgPicture.asset('assets/icon/pause_green.svg',color: GREEN_MID_COLOR,)
              : SvgPicture.asset('assets/icon/play_green.svg',color: GREEN_MID_COLOR,),
        ),
      ],
    );
  }
}
