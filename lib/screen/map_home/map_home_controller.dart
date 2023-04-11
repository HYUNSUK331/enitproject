import 'package:enitproject/const/const.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/service/storylist_network_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  Completer<GoogleMapController> _controller = Completer();

  Future<void> gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
  }

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


  Widget buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            for(int i = 0; i < latLngList.length; i++ )
              SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  latLngList[1].image.toString(),
                  33.49766527106121, 126.53094118653355,"Gramercy Tavern"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(String _image, double lat,double long,String restaurantName) {
    return  GestureDetector(
      onTap:()async{
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


      child:Container(
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
        SizedBox(height:5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Text(
                      "4.1",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),

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
        SizedBox(height:5.0),
        Container(
            child: Text(
              "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
        SizedBox(height:5.0),
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
