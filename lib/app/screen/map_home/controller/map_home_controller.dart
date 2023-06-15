import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/repository/user_repository.dart';
import 'package:enitproject/service/auth_service.dart';
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
  RxnString allowPermissionStr = RxnString('');


  void circleColorList() {  // 색을 담아줄 rxlist
    invisibleTableRowSwitchList1 = RxList<Color>.generate(latLngList.length, (int index) => Colors.black);
  }

  /// 초기화
  @override
  void onInit() async{
    EasyLoading.show();
    await loadMore();
    EasyLoading.dismiss();
    super.onInit();
  }

  loadMore() async{
    await Future.wait([
      storyListNetworkRepository.getStoryListModel().then((value) => {  // DB에서 위도 경도 받아올때 사용하기
        latLngList(value)
      }),
      checkPermission().then((value) => {
        allowPermissionStr.value = value
      })
    ]);
  }



  void updateMarker2(data){
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
        /// 여기서 리스트에 storykey를 넣어줘
        invisibleTableRowSwitchList1[i] = GREEN_BRIGHT_COLOR; // 초록색으로 변경해줘
        StoryService.to.changeTrueBadgeColor(i); // 처음에 DB에서 가져와 로컬에 저장한 리스트 -> 이 릿리스트도 초록색으로 변경해주기

        /// 원에 들어오면 알림 띄우기
        if (boolCheck == true &&
            !AuthService.to.userModel.value!.circle_list.contains(MapHomeController.to.latLngList[i].storyPlayListKey)) { // 이건 한번만나오게 설정 완료
          NotificationUtils.initNotification(i); // 여기 넣으면 원에 들어올 때 알람
          NotificationUtils.showNotification(StoryService.to.storyList[i].title.toString()); // 알림 보여주는 메인
          boolCheck = false;  // 다시 들어오면 알림 안 뜨게 하기
          if(AuthService.to.userModel.value != null){
            AuthService.to.userModel.value?.circle_list.add(MapHomeController.to.latLngList[i].storyPlayListKey.toString());
            AuthService.to.userModel.refresh();
          }
          userRepository.updateCircleColor2(AuthService.to.userModel.value?.circle_list, '${AuthService.to.userModel.value?.userKey}');

        }


      } else if (AuthService.to.userModel.value!.circle_list.contains(MapHomeController.to.latLngList[i].storyPlayListKey)) {
        print("###############################");
        invisibleTableRowSwitchList1[i] =
            LIGHT_BLUE_COLOR;
      }
      else { // list에 나온 색깔 보여주기!! yellow or blue
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        invisibleTableRowSwitchList1[i] =
            LIGHT_YELLOW_COLOR;
        StoryService.to.changeFalseBadgeColor(i);
      }
    }
  }


  /// 구글맵 사용
  void onMapCreated(GoogleMapController controller){  // 처음 한번만 들어온다.
    mapController = controller;
  }

  bool choolCheckDone = false;
  GoogleMapController? mapController;
  final Completer<GoogleMapController> _controller = Completer();

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
}
