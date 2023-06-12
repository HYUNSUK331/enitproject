import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/utils/notification.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/repository/storylist_network_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapHomeController extends GetxController{

  static MapHomeController get to => Get.find();

  RxList<StoryListModel> latLngList = <StoryListModel>[].obs;  // 내용은 story의 모든 내용이 있지만 letlng만 가져와 사용할꺼니까 이름은 letlngList
   Rx<double> initSize = 1.0.obs;  // 이게 변하는 시점에 초기화 필요

  bool boolCheck = true;
  RxList invisibleTableRowSwitchList1 = RxList<dynamic>();


  void circleColorList() {  // 색을 담아줄 rxlist
    invisibleTableRowSwitchList1 = RxList<Color>.generate(latLngList.length, (int index) => Colors.black);
  }

  /// 원의 색을 정해주는 기능
  /// 색들은 db에 저장되어있음 삭제하고 다시 다운 받아도 기기가 같으면 서클 색상은 같다.
  /// 이거를 유저에 따른 색상변경으로 변경시켜주기..? 그럼 로그인 안 한사람은...?
  void updateMarker(data){
    // print(snapshot.data); 위치 정보를 계속가져온다. 계속 업데이트 되는데 이걸 계속 다른페이지에 보내주면 힘들다.
    for (int i = 0; i < MapHomeController.to.latLngList.length; i++) {  // 이야기의 수만큼 반복한다.
      LatLng storyLat = LatLng(MapHomeController.to.latLngList[i].latitude ?? 0.0, MapHomeController.to.latLngList[i].longitude ?? 0.0); // 이야기가 있는 좌표

      final start = data;  //내 위치
      final end = storyLat;  // 이야기 위치

      final distance = Geolocator.distanceBetween( // 내위치와 이야기의 위치 사이
          start.latitude, start.longitude, end.latitude,
          end.longitude);

      if (distance < 40) { // 범위에 들어오면!
        // 여기서 로컬 list에서 bool 값 확인하고 노란색이면 아래 실행
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1");
        invisibleTableRowSwitchList1[i] = GREEN_BRIGHT_COLOR; // 초록색으로 변경해줘
        StoryController.to.changeTrueBadgeColor(i); // 처음에 DB에서 가져와 로컬에 저장한 리스트 -> 이 릿리스트도 초록색으로 변경해주기

        /// 원에 들어오면 알림 띄우기
        if (boolCheck == true &&
            MapHomeController.to.latLngList[i].circleColor == true) { // 이건 한번만나오게 설정 완료
          NotificationUtils.initNotification(i); // 여기 넣으면 원에 들어올 때 알람
          NotificationUtils.showNotification(StoryController.to.storyList[i].title.toString()); // 알림 보여주는 메인
          boolCheck = false;  // 다시 들어오면 알림 안 뜨게 하기
          MapHomeController.to.latLngList[i].circleColor = false;  // 한번 초록색으로 변하면 circleColor을 false로 변환시켜주면 기본색상이 파란색이된다.
          storyListNetworkRepository.updateCircleColor(MapHomeController.to.latLngList[i].storyPlayListKey.toString(), false);

        }


      } else if (MapHomeController.to.latLngList[i].circleColor ==  // 한번이라도 들어왔으면 원 색상을 파랑으로 변경해주기
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

  /// 구글맵 사용
  void onMapCreated(GoogleMapController controller){  // 처음 한번만 들어온다.
    mapController = controller;
  }

  @override
  void onInit() async{
    EasyLoading.show();
    await loadMore();
    EasyLoading.dismiss();
    super.onInit();
  }

  loadMore() async{
    await storyListNetworkRepository.getStoryListModel().then((value) => {  // DB에서 위도 경도 받아올때 사용하기
      latLngList(value)
    });
  }


  bool choolCheckDone = false;
  GoogleMapController? mapController;
  Completer<GoogleMapController> _controller = Completer();

  Future<void> gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
  }

  /// 지금 시작시 우리 초기 위치
  final location = Geolocator.getCurrentPosition();
  static double lat =  33.49766527106121;
  static double lng =  126.53094118653355;
  static final LatLng companyLatLng = LatLng(lat, lng);
  static final CameraPosition initialPosition = CameraPosition(  //지도 위치 초기화 및 우리가 바라볼 곳
    target: companyLatLng,
    zoom: 15,
  );




  /// 위치 권한 받아오기
  Future<String> checkPermission() async{    // 처음에 권한 받아오는 과정
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled(); // 위치권한을 받아오려고 하는 것

    if(!isLocationEnabled){
      return '위치 서비스를 황성화 해주세요.';
    }
    LocationPermission checkPermission = await Geolocator.checkPermission();  // 현재 앱이 가지고있는 위치서비스에 관한 권한을 가져오는 것

    if(checkPermission == LocationPermission.denied){
      checkPermission = await Geolocator.requestPermission();

      if(checkPermission == LocationPermission.denied){
        return '위치 권한을 허가해 주세요';
      }
    }

    if(checkPermission == LocationPermission.deniedForever){
      return '앱의 위치 권한을 세팅에서 허가해주세요';
    }

    return '위치 권한이 허가 되었습니다.';
  }













  //
  // Widget buildContainer() {
  //   return Align(
  //     alignment: Alignment.bottomLeft,
  //     child: Container(
  //       margin: EdgeInsets.symmetric(vertical: 20.0),
  //       height: 150.0,
  //       child: ListView(
  //         scrollDirection: Axis.horizontal,
  //         children: <Widget>[
  //           for(int i = 0; i < latLngList.length; i++ )
  //             SizedBox(width: 10.0),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: _boxes(
  //                 latLngList[1].image.toString(),
  //                 33.49766527106121, 126.53094118653355,"Gramercy Tavern"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // Widget _boxes(String _image, double lat,double long,String restaurantName) {
  //   return  GestureDetector(
  //     onTap:()async{
  //       if(mapController == null){
  //         return;
  //       }
  //       final location = await Geolocator.getCurrentPosition();
  //
  //       mapController!.animateCamera(CameraUpdate.newLatLng(
  //         LatLng(location.latitude, location.longitude
  //         ),
  //       ),
  //       );
  //     },
  //
  //
  //     child:Container(
  //       child: new FittedBox(
  //         child: Material(
  //             color: Colors.white,
  //             elevation: 14.0,
  //             borderRadius: BorderRadius.circular(24.0),
  //             shadowColor: Color(0x802196F3),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: <Widget>[
  //                 Container(
  //                   width: 180,
  //                   height: 200,
  //                   child: ClipRRect(
  //                     borderRadius: new BorderRadius.circular(24.0),
  //                     child: Image(
  //                       fit: BoxFit.fill,
  //                       image: NetworkImage(_image),
  //                     ),
  //                   ),),
  //                 Container(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: myDetailsContainer1(restaurantName),
  //                   ),
  //                 ),
  //
  //               ],)
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget myDetailsContainer1(String restaurantName) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.only(left: 8.0),
  //         child: Container(
  //             child: Text(restaurantName,
  //               style: TextStyle(
  //                   color: Color(0xff6200ee),
  //                   fontSize: 24.0,
  //                   fontWeight: FontWeight.bold),
  //             )),
  //       ),
  //       SizedBox(height:5.0),
  //       Container(
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: <Widget>[
  //               Container(
  //                   child: Text(
  //                     "4.1",
  //                     style: TextStyle(
  //                       color: Colors.black54,
  //                       fontSize: 18.0,
  //                     ),
  //                   )),
  //
  //               Container(
  //                   child: Text(
  //                     "(946)",
  //                     style: TextStyle(
  //                       color: Colors.black54,
  //                       fontSize: 18.0,
  //                     ),
  //                   )),
  //             ],
  //           )),
  //       SizedBox(height:5.0),
  //       Container(
  //           child: Text(
  //             "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
  //             style: TextStyle(
  //               color: Colors.black54,
  //               fontSize: 18.0,
  //             ),
  //           )),
  //       SizedBox(height:5.0),
  //       Container(
  //           child: Text(
  //             "Closed \u00B7 Opens 17:00 Thu",
  //             style: TextStyle(
  //                 color: Colors.black54,
  //                 fontSize: 18.0,
  //                 fontWeight: FontWeight.bold),
  //           )),
  //     ],
  //   );
  // }

}
