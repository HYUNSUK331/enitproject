import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHomeItem extends GetView<MapHomeController> {

  final int index;

  const MapHomeItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const SizedBox(width: 10.0),
      // for(int i = 0; i < MapHomeController.to.latLngList.length; i++)
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: _boxes(
          StoryService.to.storyList[index].image.toString(),
          StoryService.to.storyList[index].latitude!.toDouble(),
          StoryService.to.storyList[index].longitude!.toDouble(),
          StoryService.to.storyList[index].title.toString(),
        ),
      ),
    ],
    );
  }

  Widget _boxes(String image, double lat, double long, String restaurantName) {
    return GestureDetector(
      onTap: () async {
        if (controller.mapController == null) {
          return;
        }
        controller.mapController!.animateCamera(
          CameraUpdate.newLatLng( // story 클릭 시 그 위치로 이동시키기
            LatLng(lat, long
            ),
          ),
        );
      },

      child: FittedBox(
        child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: const Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(image),
                    ),
                  ),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: myDetailsContainer1(restaurantName),
                ),

              ],)
        ),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(restaurantName,
            style: const TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        Text("${StoryService.to.storyList.length}"),
        const SizedBox(height: 5.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "(946)",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        const Text(
          "Closed \u00B7 Opens 17:00 Thu",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2 2번

class MapHomeItem2 extends GetView<MapHomeController> {

  final int index;
  const MapHomeItem2({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          // SizedBox(width: 5.0),
          // for(int i = 0; i < MapHomeController.to.latLngList.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: _boxes(
                StoryService.to.storyList[index].image.toString(),
                StoryService.to.storyList[index].latitude!.toDouble(),
                StoryService.to.storyList[index].longitude!.toDouble(),
                StoryService.to.storyList[index].title.toString(),
                StoryService.to.storyList[index].addressSearch.toString(),
                StoryService.to.storyList[index].addressDetail.toString(),
              ),
            ),
          ),

        ],
      )
      ,);
  }

  /// 리스트에 가로 한 줄
  Widget _boxes(String image, double lat, double long, String restaurantName,String addressSearch, String addressDetail) {
    return GestureDetector(  // 박스 클릭 했을 때 나오는 모습
      onTap: () {
        if (controller.mapController == null) {
          return;
        }
        controller.mapController!.animateCamera(
          CameraUpdate.newLatLng( // story 클릭 시 그 위치로 이동시키기
            LatLng(lat, long
            ),
          ),
        );
        controller.initSize.value = 0.3;
      },

      child: InkWell(
        child: Material( // 상자 시작
            color: Colors.white,  // 이야기 상자 색
            elevation: 0.0,  // 그림자 진하기
            // borderRadius: BorderRadius.circular(10.0),  //라운드 지게 만드는거
            // shadowColor: Color(0x802196F3), // 그림자 색
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,  클래스 사이를 뛰어둔다. 지금은 사용하면 너무 틀어져
              children: <Widget>[
                Padding(                  // 이미지 넣어주기
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(   //이미지 사이즈 바꾸기
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(image),
                      ),
                    ),),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: myDetailsContainer2(restaurantName,addressSearch,addressDetail),
                  ),
                ),
                const SizedBox(width: 5,),
                Obx(() => AuthService.to.userModel.value!.favoriteList.contains(StoryService.to.storyList[index].storyPlayListKey)?
                IconButton(
                  onPressed: () => {
                    StoryService.to.updateUserUnFav('${StoryService.to.storyList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
                  },
                  icon: SvgPicture.asset('assets/icon/heart_green.svg',
                    color: GREEN_MID_COLOR,),
                )
                    :
                IconButton(
                    onPressed: ()=>{
                      StoryService.to.updateUserFav('${StoryService.to.storyList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
                    },
                    icon: SvgPicture.asset('assets/icon/heart_gray_line.svg',
                      color: Colors.grey,),
                    padding: EdgeInsets.zero
                )
                ),
              ],
            )
        ),
      ),
    );
  }
  /// 제목, 주소
  Widget myDetailsContainer2(String restaurantName, String addressSearch, String addressDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          addressSearch,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: GREEN_DARK_COLOR,
          ),
        ),
        const SizedBox(height: 10.0,),
        Row(
          children: [
            Text(restaurantName,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 5.0,),

            /// 서클컬러
            Obx(() =>
            AuthService.to.userModel.value!.circleList.contains(StoryService.to.storyList[index].storyPlayListKey) ?
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
            )
          ],
        ),
        const SizedBox(height: 5.0),
        Text(
          addressDetail,
          style: const TextStyle(
            fontSize: 13.0,
          ),
        ),
      ],
    );
  }
}