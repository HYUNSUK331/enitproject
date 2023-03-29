import 'package:enitproject/screen/story/story_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:just_audio/just_audio.dart';
import '../../const/color.dart';

class StoryScreen extends GetView<StoryController> {
  const StoryScreen({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
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
                  Navigator.pop(context);
                },
                ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(Icons.favorite_border),
                color: Colors.grey,
                iconSize: 35.0,
                onPressed: (){
                  //관심목록 담기
                },
                  ),
            )
          ],
        ),


        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.0,),
                Container(
                  child: Column(
                    children: [
                      Text(
                        '${controller.storyList[0].title}',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${controller.storyList[0].addressDetail}',
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          TextButton(
                              child: Text(
                                  '지도보기',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: GREEN_BRIGHT_COLOR,
                                ),
                              ),
                              onPressed: (){},
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0,),
                Image.network(
                  '${controller.storyList[0].image}',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 15.0,),

                IconButton(
                  icon: Icon(
                    Icons.headphones,
                    color: GREEN_DARK_COLOR,
                    size: 30.0,
                  ),
                  onPressed: controller.audioPlayer.play,
                ),
                SizedBox(height: 15.0,),
                Container(
                  child: Text(
                    '${controller.storyList[0].script}',
                    style: TextStyle(
                      fontSize: 15.0
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
