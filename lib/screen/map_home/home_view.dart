import 'package:enitproject/screen/map_home/map_home_controller.dart';
import 'package:enitproject/screen/map_home/map_pin_list.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// 시작화면 지정하기


class HomeView extends GetView<MapHomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MapHomeController()); // 페이지 마다 불러오기
    MapHomeController mapController = Get.find();
    LatLng companyLat = MapHomeController.companyLatLng;

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
                  // print(snapshot.data); 위치 정보를 계속가져온다.
                  bool isWithinRange = false; // 우리가 지정한 원안에 들어가있는지 아닌지 확인하는 bool

                  if (snapshot.hasData) {
                    final start = snapshot.data!;
                    final end = companyLat;

                    final distance = Geolocator.distanceBetween(
                        start.latitude, start.longitude, end.latitude,
                        end.longitude);
                    if (distance < MapHomeController.okDistence) {
                      isWithinRange = true;
                    }
                  }
                  return Column(
                    children: [
                      _CustomGoogleMap(initialPosition: MapHomeController.initialPosition, circle: mapController.choolCheckDone ? MapHomeController.checkDoneCircle: isWithinRange ? MapHomeController.withinDistanceCircle : MapHomeController.notWithinDistanceCircle ,onMapCreated: mapController.onMapCreated,marker: MapHomeController.marker),  // 굳이 여기서 안 받아도 된다. 아래 class에서 해결하기
                      TestButton(test: controller.latLngList[1].latitude,)
                    ],
                  );


                  /*
                  SizedBox(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), // 스크롤 내려가지 못하게
                          itemCount: controller.latLngList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MapPinList(
                                index: index, isWithinRange: isWithinRange);
                          })
                    // initialPosition이 초기 화면 값이니까 이거 우리 위치로 바꿔주자
                  )
                   ;
                   */

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


class TestButton extends StatelessWidget {   // 테스트용
  final dynamic test;
  const TestButton({required this.test,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: 1,child: Text('$test'));
  }
}


class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;
  final Circle circle;
  final Marker marker;
  final MapCreatedCallback onMapCreated;
  const _CustomGoogleMap({required this.initialPosition, required this.circle,required this.marker,required this.onMapCreated,Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: Set.from([circle]),
        markers: getmarkers(),
        onMapCreated: onMapCreated,
      ),
    );
  }
}

final Set<Marker> markers = new Set();
const LatLng showLocation = const LatLng(33.49766527106121, 126.53094118653355);
Set<Marker> getmarkers() { //markers to place on map
    markers.add(Marker( //add first marker
      markerId: MarkerId(showLocation.toString()),
      position: showLocation, //position of marker
      infoWindow: InfoWindow( //popup info 
        title: 'PORT',
        snippet: '안녕하세요 포트에요',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    markers.add(Marker( //add second marker
      markerId: MarkerId(showLocation.toString()),
      position: LatLng(33.49266527106121, 126.52594118653355), //position of marker
      infoWindow: InfoWindow( //popup info 
        title: '식당입니다',
        snippet: '맛점 하세요',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    markers.add(Marker( //add third marker
      markerId: MarkerId(showLocation.toString()),
      position: LatLng(33.50266527106121, 126.53594118653355), //position of marker
      infoWindow: InfoWindow( //popup info 
        title: '카페에요',
        snippet: '음료 드세요',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    //add more markers here 


  return markers;
}