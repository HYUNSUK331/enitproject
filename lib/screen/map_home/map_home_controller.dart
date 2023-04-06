import 'package:enitproject/const/const.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/service/storylist_network_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHomeController extends GetxController{

  static MapHomeController get to => Get.find();

  RxList<StoryListModel> latLngList = <StoryListModel>[].obs;  // 내용은 story의 모든 내용이 있지만 letlng만 가져와 사용할꺼니까 이름은 letlngList

  @override
  void onInit() async{
    await storyListNetworkRepository.getStoryListModel().then((value) => {  // DB에서 위도 경도 받아올때 사용하기
      latLngList(value)
    });

    super.onInit();
  }

  @override
  void onReady() async{
    super.onReady();
  }
  @override
  void onClose() {
    super.onClose();
  }




  bool choolCheckDone = false;
  GoogleMapController? mapController;


  static double lat =  33.49766527106121;
  static double lng =  126.53094118653355;

  static final LatLng companyLatLng =
  LatLng(lat, lng);

  static final CameraPosition initialPosition = CameraPosition(  //지도 위치 초기화 및 우리가 바라볼 곳
    target: companyLatLng,
    zoom: 15,

  );

  void onMapCreated(GoogleMapController controller){
    mapController = controller;
  }

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

  AppBar renderAppBar() {
    return AppBar(
      title: Text(
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
          if(mapController == null){
            return;
          }
          final location = await Geolocator.getCurrentPosition();

          mapController!.animateCamera(CameraUpdate.newLatLng(
            LatLng(location.latitude, location.longitude
            ),
          ),
          );
        },
          icon:Icon(Icons.my_location,
            color: Colors.blue,
          ),
        )
      ],
    );
  }


}
