import 'package:enitproject/screen/map_home/map_home_component/map_home_googlemap.dart';
import 'package:enitproject/screen/map_home/map_home_controller.dart';
import 'package:enitproject/screen/map_home/map_pin_list.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../story/story_controller.dart';
// 시작화면 지정하기


class HomeView extends GetView<MapHomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MapHomeController()); // 페이지 마다 불러오기
    MapHomeController mapController = Get.find();

    RxList invisibleTableRowSwitchList1 = RxList<dynamic>();
    void buildInvisibleTableRowSwitch(int switchLength) {
      invisibleTableRowSwitchList1 = RxList<Color>.generate(switchLength, (int index) => Colors.black);
    }
     
    return Scaffold(
      appBar: mapController.renderAppBar(), // 앱바를 컨트롤러에서 가져왔음;;
      body: FutureBuilder(
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

                  buildInvisibleTableRowSwitch(MapHomeController.to.latLngList.length);  // boollist
                  for(int i = 0; i < MapHomeController.to.latLngList.length; i++ ) {
                    LatLng companyLat = LatLng(MapHomeController.to.latLngList[i].latitude ?? 0.0, MapHomeController.to.latLngList[i].longitude ?? 0.0);

                    if (snapshot.hasData) {
                      final start = snapshot.data!;
                      final end = companyLat;

                      final distance = Geolocator.distanceBetween(
                          start.latitude, start.longitude, end.latitude,
                          end.longitude);
                      if (distance < 40) {
                        invisibleTableRowSwitchList1[i] = Colors.red;
                        StoryController.to.changeTrueBadgeColor(i);
                      }else{
                        invisibleTableRowSwitchList1[i] = Colors.blue;
                        StoryController.to.changeFalseBadgeColor(i);
                      }
                    }
                  }
                  return Column(
                    children: [
                      CustomGoogleMap(onMapCreated: mapController.onMapCreated, circle: invisibleTableRowSwitchList1),  // 굳이 여기서 안 받아도 된다. 아래 class에서 해결하기
                      TestButton(test: invisibleTableRowSwitchList1,)
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
}
