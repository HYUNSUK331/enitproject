import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:enitproject/app/screen/map_home/view/map_home_component/map_home_googlemap.dart';
import 'package:enitproject/app/screen/map_home/view/map_home_component/map_home_items.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/const/color.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 처음 나오는 지도 화면
/// 여기가 계속 처음 화면처럼 사용된다. 다시 들어올 때 마다 초기화...
class HomeView extends GetView<MapHomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JJurang',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          /// 현재위치로 화면 이동
          IconButton(
            onPressed: () async {
              if (controller.mapController == null) {
                // null 이면 return
                return;
              }
              final location = await Geolocator.getCurrentPosition();
              controller.mapController?.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(location.latitude, location.longitude),
                ),
              );
            },
            icon: const Icon(
              Icons.my_location,
              color: Colors.black,
            ),
          )
        ],
      ),
      extendBodyBehindAppBar: true,

      /// 위치 권한 받기
      /// futurebuilder를 obx로 변경
      body: Obx(() => controller.allowPermissionStr.value == '위치 권한이 허가 되었습니다.'
          ? StreamBuilder<Position>(
              // 데이터를 여러번 받아올때 사용
              stream: Geolocator.getPositionStream(),
              builder: (context, snapshot) {
                controller.circleColorList(); // rxlist로 색이 담긴 리스트
                /// 핵심기능
                /// 서클 색 변경하고 알림띄우기
                if (snapshot.hasData) controller.updateMarker2(snapshot.data);
                return Stack(
                  children: [
                    ///구글맵
                    CustomGoogleMap(
                        onMapCreated: controller.onMapCreated,
                        circle: controller.invisibleTableRowSwitchList1),
                    // 서클 색 설정
                    ///이야기 리스트
                    _buildContainer2(),
                  ],
                );
              })
          : const Center(
              child: CircularProgressIndicator(), // 대기중 서클 띄워라
            )),
    );
  }

  /// story list
  Widget _buildContainer2() {
    return Obx(() => DraggableScrollableSheet(
          //obx 적용해서 불들어오면 바로바로 보이게 하기 / DraggableScrollableSheet -> 아래서 위로 끌어올리는 리스트
          maxChildSize: controller.initSize.value,
          initialChildSize: 0.3, // 초기 사이즈

          builder: (context, sheetController) => Container(
            // DraggableScrollableSheet에 들어갈 리스트
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),

            child: Stack(children: [
              IgnorePointer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(/// 스크롤바 위에 작은 선
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        height: 6,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              ListView.builder(
                controller: sheetController,
                itemCount: StoryService.to.storyList.length,
                itemBuilder: (BuildContext context, int index) {
                  // if (controller.initSize.value == 0.3) {
                  //   controller.initSize.value = 1.0;
                  // } // 여기 에러 나는데 이거 바꾸기
                  return MapHomeItem2(index: index);
                },
              ),
            ]),
          ),
        ));
  }
}
