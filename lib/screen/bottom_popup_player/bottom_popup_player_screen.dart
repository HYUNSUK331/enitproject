import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import 'bottom_popup_player_controller.dart';

class BottomPopupPlayer extends GetView<BottomPopupPlayerController> {
  final int storyIndex;
  const BottomPopupPlayer({
    required this.storyIndex,
    Key? key
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 300,
          height: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.deepPurple[200],),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
              ),
              // Padding
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    '제목',
                  ),
                ],
              ),

              // Padding between first 2 columns and Icons
              Expanded(child: SizedBox.expand()),
            ],
          ),
        ),
      ]
    );
  }
}