import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:enitproject/app/screen/bottom_popup_player/controller/bottom_popup_player_controller.dart';
import 'package:enitproject/app/screen/favorite_list/controller/favorite_controller.dart';
import 'package:enitproject/app/screen/story/binding/story_binding.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/story/view/story_screen.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
            title: const Text(
              '관심목록',
              style: TextStyle(
                  color: Colors.black
              ),
            ),
          ),
          body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 15.0
          ),
          child:
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ /// (하트) LIKE (좋아요 수)
              Row(
                children: [
                  SvgPicture.asset('assets/icon/heart_green.svg',
                    color: GREEN_MID_COLOR, width: 20, height: 20,
                  ),
                  const SizedBox(width: 5,),
                  const Text(
                    'LIKE',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Obx(()=>
                  Text('${AuthService.to.userModel.value?.favoriteList.length}',
                    style: const TextStyle(
                        color: FONT_MID_BLACK_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 20
                    ),)
                  )
                ],
              ),
              const Divider(height: 5,),
              const SizedBox(height: 30,),
              Expanded(
                ///하트 누르고 취소할때마다 리스트 바껴야해서 obx로 일단 해둠...
                child:
                ListView.builder(
                        itemCount: AuthService.to.userModel.value?.favoriteList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child:
                            SizedBox(
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
                                    const SizedBox(width: 10,),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ///검색용 주소
                                          Text('${controller.favStoryList[index].addressSearch}',
                                            style: const TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              color: GREEN_DARK_COLOR,
                                            ),
                                          ),
                                          const SizedBox(height: 10.0,),
                                          Row(
                                            children: [
                                              ///이야기 제목
                                              Text(
                                                '${controller.favStoryList[index].title}',
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              const SizedBox(width: 5.0,),
                                              ///배지 색
                                              Obx(() => AuthService.to.userModel.value!.circleList.contains(controller.favStoryList[index].storyPlayListKey)?
                                              const badges.Badge(
                                                badgeStyle: BadgeStyle(
                                                  badgeColor: GREEN_BRIGHT_COLOR,
                                                ),
                                                showBadge: true,
                                              )
                                                  :
                                              const badges.Badge(
                                                badgeStyle: BadgeStyle(
                                                  badgeColor: LIGHT_YELLOW_COLOR,
                                                ),
                                                showBadge: true,
                                              ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0,),
                                          ///상세주소
                                          Text(
                                            '${controller.favStoryList[index].addressDetail}',
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    ///좋아요 하트
                                    Obx(() => AuthService.to.userModel.value!.favoriteList.contains(controller.favStoryList[index].storyPlayListKey)?/// isLike 바라보다가 변경되면 아래 부분만 변경
                                    IconButton(
                                      onPressed: () => {
                                        StoryService.to.updateUserUnFav('${controller.favStoryList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
                                      },
                                      icon: SvgPicture.asset('assets/icon/heart_green.svg',
                                        color: GREEN_MID_COLOR,),
                                    )
                                        :
                                    IconButton(
                                        onPressed: ()=>{
                                          StoryService.to.updateUserFav('${controller.favStoryList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
                                        },
                                        icon: SvgPicture.asset('assets/icon/heart_gray_line.svg',
                                          color: Colors.grey,),
                                        padding: EdgeInsets.zero
                                    )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ///누르면 이야기 페이지로 이동
                            onTap: (){
                              ///배지의 불이 초록색일때만
                              /// 서클 변경예정
                              if(controller.favStoryList[index].changeStoryColor == GREEN_BRIGHT_COLOR)
                              {
                                Get.to(() =>
                                ///관심목록 리스트랑 이야기 리스트의 인덱스가 달라서 'controller.storykey'로 한번 찾아줌.
                                StoryScreen(storyIndex: controller.storykey(index),),binding: StoryBinding(storyIndex: index,));
                                StoryService.to.setOpenPlay(controller.storykey(index),);
                              }
                            },
                          );
                        }
                    ),
                ),
              ///하단 팝업 띄우기
              Obx(() => BottomPopupPlayerController.to.isPopup.value?
              const SizedBox(height: 90,) : const SizedBox.shrink()
              )
            ],
          ),
          )
    );
  }

}