import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:enitproject/app/screen/favorite_list/controller/favorite_controller.dart';
import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/story/view/story_screen.dart';
import 'package:enitproject/app/screen/user/controller/user_controller.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';


class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return SafeArea(
      top: true,

      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 15.0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              /// (하트) LIKE (좋아요 수)
              Row(
                children: [
                  SvgPicture.asset('assets/icon/heart_green.svg',
                    color: GREEN_MID_COLOR, width: 65, height: 65,
                  ),
                  SizedBox(width: 15,),
                  Text(
                    'LIKE',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 65
                    ),
                  ),
                  SizedBox(width: 15,),
                  Text('${AuthService.to.userModel.value?.favorite_list.length}',
                    style: TextStyle(
                        color: FONT_MID_BLACK_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 65
                    ),)
                ],
              ),
              SizedBox(height: 50,),

              Expanded(
                ///하트 누르고 취소할때마다 리스트 바껴야해서 obx로 일단 해둠...
                child: Obx(()=>
                    ListView.builder(
                        itemCount: AuthService.to.userModel.value?.favorite_list.length,
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
                                    ///이미지
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        '${controller.favStoryList[index].image}',
                                        width: 100, height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ///검색용 주소
                                          Text('${controller.favStoryList[index].addressSearch}',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: GREEN_DARK_COLOR,
                                            ),
                                          ),
                                          SizedBox(height: 10.0,),
                                          Row(
                                            children: [
                                              ///이야기 제목
                                              Text(
                                                '${controller.favStoryList[index].title}',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              SizedBox(width: 5.0,),
                                              ///배지 색
                                              Obx(() => MapHomeController.to.latLngList[index].circleColor == false?
                                              badges.Badge(
                                                badgeStyle: BadgeStyle(
                                                  badgeColor: GREEN_BRIGHT_COLOR,
                                                ),
                                                showBadge: true,
                                              )
                                                  :
                                              badges.Badge(
                                                badgeStyle: BadgeStyle(
                                                  badgeColor: LIGHT_YELLOW_COLOR,
                                                ),
                                                showBadge: true,
                                              ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.0,),
                                          ///상세주소
                                          Text(
                                            '${controller.favStoryList[index].addressDetail}',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    ///좋아요 하트
                                    IconButton(
                                      onPressed: () => {
                                        ///하트 취소
                                        UserController.to.updateUserUnFav('${controller.favStoryList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
                                      },
                                      icon: SvgPicture.asset('assets/icon/heart_green.svg',
                                        color: GREEN_MID_COLOR,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ///누르면 이야기 페이지로 이동
                            onTap: (){
                              ///배지의 불이 초록색일때만
                              /// 서클 변경예정
                              if(MapHomeController.to.latLngList[index].circleColor == false)
                              {
                                Get.to(() =>
                                ///관심목록 리스트랑 이야기 리스트의 인덱스가 달라서 'controller.storykey'로 한번 찾아줌.
                                StoryScreen(storyIndex: controller.storykey(index),),);
                                StoryController.to.setOpenPlay(controller.storykey(index),);
                              }
                            },
                          );
                        }
                    ),
                ),
              ),
              ///하단 팝업 띄우기
              Obx(() => BottomPopupPlayerController.to.isPopup.value?
              SizedBox(height: 90,) : SizedBox.shrink()
              )
            ],
          ),
        ),

      ),
    );
  }

}