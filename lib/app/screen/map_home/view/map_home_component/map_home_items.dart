import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/user/controller/user_controller.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/foundation.dart';
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
      SizedBox(width: 10.0),
      // for(int i = 0; i < MapHomeController.to.latLngList.length; i++)
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: _boxes(
          MapHomeController.to.latLngList[index].image.toString(),
          MapHomeController.to.latLngList[index].latitude!.toDouble(),
          MapHomeController.to.latLngList[index].longitude!.toDouble(),
          MapHomeController.to.latLngList[index].title.toString(),
        ),
      ),
    ],
    );
  }

  Widget _boxes(String _image, double lat, double long, String restaurantName) {
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

      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName),
                    ),
                  ),

                ],)
          ),
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
          child: Container(
              child: Text(restaurantName,
                style: TextStyle(
                    color: Color(0xff6200ee),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              )),
        ),
        // Obx(() =>
        // StoryController.to.storyList[index].changeStoryColor ==
        //     GREEN_BRIGHT_COLOR ?
        // Badge(
        //   badgeStyle: BadgeStyle(
        //     badgeColor: GREEN_BRIGHT_COLOR,
        //   ),
        //   showBadge: true,
        //
        // )
        //     :
        // Badge(
        //   badgeStyle: BadgeStyle(
        //     badgeColor: LIGHT_YELLOW_COLOR,
        //   ),
        //   showBadge: true,
        // ),
        // ),
        Text("${MapHomeController.to.latLngList.length}"),
        SizedBox(height: 5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Text(
                      "(946)",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
              ],
            )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
              "Closed \u00B7 Opens 17:00 Thu",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            )),
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
    return Padding(padding: EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          // SizedBox(width: 5.0),
          // for(int i = 0; i < MapHomeController.to.latLngList.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: _boxes(
                MapHomeController.to.latLngList[index].image.toString(),
                MapHomeController.to.latLngList[index].latitude!.toDouble(),
                MapHomeController.to.latLngList[index].longitude!.toDouble(),
                MapHomeController.to.latLngList[index].title.toString(),
                MapHomeController.to.latLngList[index].addressSearch.toString(),
                MapHomeController.to.latLngList[index].addressDetail.toString(),
              ),
            ),
          ),

        ],
      )
      ,);
  }

  /// 리스트에 가로 한 줄
  Widget _boxes(String _image, double lat, double long, String restaurantName,String addressSearch, String addressDetail) {
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

      child: Container(
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
                    child: Container(   //이미지 사이즈 바꾸기
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(10.0),
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(_image),
                        ),
                      ),),
                  ),
                  Expanded(
                    child: Container(        // 여기부터 글
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: myDetailsContainer2(restaurantName,addressSearch,addressDetail),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Obx(() => AuthService.to.userModel.value!.favorite_list.contains(StoryController.to.storyList[index].storyPlayListKey)?
                  IconButton(
                    onPressed: () => {
                      UserController.to.updateUserUnFav('${StoryController.to.storyList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
                    },
                    icon: SvgPicture.asset('assets/icon/heart_green.svg',
                      color: GREEN_MID_COLOR,),
                  )
                      :
                  IconButton(
                      onPressed: ()=>{
                        UserController.to.updateUserFav('${StoryController.to.storyList[index].storyPlayListKey}', ('${AuthService.to.userModel.value?.userKey}'))
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
        SizedBox(height: 10.0,),
        Row(
          children: [
            Text(restaurantName,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 5.0,),
            Obx(() =>
            MapHomeController.to.latLngList[index].circleColor == false ?
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
        SizedBox(height: 5.0),
        Text(
          addressDetail,
          style: const TextStyle(
            fontSize: 13.0,
          ),
        ),


        // Container(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: <Widget>[
        //         Container(
        //             child: Text(
        //               "(946)",
        //               style: TextStyle(
        //                 color: Colors.black54,
        //                 fontSize: 18.0,
        //               ),
        //             )),
        //       ],
        //     )),
        // SizedBox(height: 5.0),
        // Container(
        //     child: Text(
        //       "Closed \u00B7 Opens",
        //       style: TextStyle(
        //           color: Colors.black54,
        //           fontSize: 18.0,
        //           fontWeight: FontWeight.bold),
        //     )),
      ],
    );
  }
}