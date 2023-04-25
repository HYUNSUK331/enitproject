import 'dart:async';

import 'package:badges/badges.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/utils/notification.dart';
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
  const HomeView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // 지역에 들어오고 0.3초 후에 알림 띄우기
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JJurang',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: ()async{
            if(controller.mapController == null){
              return;
            }
            final location = await Geolocator.getCurrentPosition();
            controller.mapController?.animateCamera(CameraUpdate.newLatLng(
              LatLng(location.latitude, location.longitude
              ),
            ),
            );
          },
            icon:const Icon(Icons.my_location, color: Colors.blue,),
          )
        ],
      ), // 앱바를 컨트롤러에서 가져왔음;;
      body: FutureBuilder( // 여기 바디에 스크롤 추가해보기
        future: controller.checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == '위치 권한이 허가 되었습니다.') {
            return StreamBuilder<Position>(
                stream: Geolocator.getPositionStream(),
                builder: (context, snapshot) {
                  controller.buildInvisibleTableRowSwitch();
                  if(snapshot.hasData) controller.updateMarker(snapshot.data);
                  return Stack(
                      children: [
                          CustomGoogleMap(
                              onMapCreated: controller.onMapCreated,
                              circle: controller.invisibleTableRowSwitchList1),
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
    return Obx(() => DraggableScrollableSheet(
          maxChildSize: controller.initSize.value,
          initialChildSize: 0.3,
          builder: (context, sheetController) =>
              Container(
                color: Colors.white70,
                  child: ListView.builder(
                    controller: sheetController,
                    itemCount: controller.latLngList.length,
                    itemBuilder: (BuildContext context, int index) {
                      // if (controller.initSize.value == 0.3) {
                      //   controller.initSize.value = 1.0;
                      // } // 여기 에러 나는데 이거 바꾸기
                      return MapHomeItem2(index: index);
                    },
                  ),

              ),
        ));
  }


  handleTimeout(context) {  // 알림 띄우고 다시는 안 띄우는 함수 만들기
    showDialog(context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('플레이리스트 이름을 입력하세요'),
            content: Container(
              width: 200, height: 70, padding: EdgeInsets.all(10),
              child: Text("이야기를 확인하시겠습니까?"
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                print("호랑이요@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
              }, child: Text('확인', style: TextStyle(fontSize: 15, color: Colors.deepPurple[800])))
            ],
          );
        });
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