import 'dart:async';

import 'package:badges/badges.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/notification.dart';
import 'package:enitproject/screen/map_home/map_home_component/map_home_googlemap.dart';
import 'package:enitproject/screen/map_home/map_home_component/map_home_items.dart';
import 'package:enitproject/screen/map_home/map_home_controller.dart';
import 'package:enitproject/screen/map_home/map_pin_list.dart';
import 'package:enitproject/screen/story/story_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../story/story_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// 시작화면 지정하기


class HomeView extends GetView<MapHomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    bool boolcheck = true;
    Get.put(MapHomeController()); // 페이지 마다 불러오기  두번 불러와도 가능한가?
    MapHomeController mapController = Get.find();

    RxList invisibleTableRowSwitchList1 = RxList<dynamic>();
    void buildInvisibleTableRowSwitch(int switchLength) {
      invisibleTableRowSwitchList1 =
      RxList<Color>.generate(switchLength, (int index) => Colors.black);
    }
    // 지역에 들어오고 0.3초 후에 알림 띄우기
    return Scaffold(
      appBar: mapController.renderAppBar(), // 앱바를 컨트롤러에서 가져왔음;;
      body: FutureBuilder( // 여기 바디에 스크롤 추가해보기
        future: mapController.checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == '위치 권한이 허가 되었습니다.') {
            return StreamBuilder<Position>(
                stream: Geolocator.getPositionStream(),
                builder: (context, snapshot) {
                  // print(snapshot.data); 위치 정보를 계속가져온다. 계속 업데이트 되는데 이걸 계속 다른페이지에 보내주면 힘들다

                  buildInvisibleTableRowSwitch(
                      MapHomeController.to.latLngList.length); // boollist
                  for (int i = 0; i <
                      MapHomeController.to.latLngList.length; i++) {
                    LatLng companyLat = LatLng(
                        MapHomeController.to.latLngList[i].latitude ?? 0.0,
                        MapHomeController.to.latLngList[i].longitude ?? 0.0);

                    if (snapshot.hasData) {
                      final start = snapshot.data!;
                      final end = companyLat;

                      final distance = Geolocator.distanceBetween(
                          start.latitude, start.longitude, end.latitude,
                          end.longitude);

                      if (distance < 40) { // 범위에 들어오면!
                        // 여기서 로컬 list에서 bool 값 확인하고 노란색이면 아래 실행
                        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1"); // 모달창 띄우는 명령어
                        invisibleTableRowSwitchList1[i] =
                            GREEN_BRIGHT_COLOR; //이 로직 돌아가는중에 오류
                        StoryController?.to.changeTrueBadgeColor(
                            i); //여기도 스쳐 지나가듯 초록색 보여주기
                        // 여기에 플레이 모달창 띄우기

                        if (boolcheck == true &&
                            MapHomeController.to.latLngList[i].circleColor ==
                                true) { // 이건 한번만나오게 설정 완료
                          showNotification(); // 알림보여주는 메인
                          boolcheck = false;
                        }
                        //만약 파란색이라면 내용 실행
                      } else
                      if (MapHomeController.to.latLngList[i].circleColor ==
                          false) {
                        print("###############################");
                        invisibleTableRowSwitchList1[i] =
                            LIGHT_BLUE_COLOR;
                      }
                      else { // list에 나온 색깔 보여주기!! yellow or blue
                        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                        invisibleTableRowSwitchList1[i] =
                            LIGHT_YELLOW_COLOR;
                        StoryController?.to.changeFalseBadgeColor(i);
                      }
                    }
                  }
                  return Stack(
                      children: [
                          CustomGoogleMap(onMapCreated: mapController.onMapCreated,
                              circle: invisibleTableRowSwitchList1),
                        // 굳이 여기서 안 받아도 된다. 아래 class에서 해결하기
                        _buildContainer2(),
                      ],
                  );
                }
            );
          }
          return Center(
            child: Text(snapshot.data),
          );
        },
      ),
    );
  }


  //###################################################################################
  Widget _buildContainer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: MapHomeController.to.latLngList.length,
        itemBuilder: (BuildContext context, int index) {
          return MapHomeItem(index: index);
        },
      ),
    );
  }

  Widget _buildContainer2() {
    return Obx(() =>
        DraggableScrollableSheet(
          maxChildSize: Get
              .find<MapHomeController>()
              .initSize
              .value,
          initialChildSize: 0.3,
          builder: (context, controller) =>
              Container(
                color: Colors.white70,
                  child: ListView.builder(
                    controller: controller,
                    itemCount: MapHomeController.to.latLngList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (Get
                          .find<MapHomeController>()
                          .initSize
                          .value == 0.3) {
                        Get
                            .find<MapHomeController>()
                            .initSize
                            .value = 1.0;
                      } // 여기 에러 나는데 이거 바꾸기
                      return MapHomeItem2(index: index);
                    },
                  ),

              ),
        ));
  }


// Widget _buildContainer1() {   스크롤 만들기 실패
//   return Expanded(
//     child: DraggableScrollableSheet(
//     initialChildSize:0.4,
//       minChildSize: 0.2,
//       maxChildSize: 0.6,
//       builder: (context, scrollController){
//     return SingleChildScrollView(
//       child: Text("ghfkddl"),
//     );
//   }
//   ),
//   );
// }
}