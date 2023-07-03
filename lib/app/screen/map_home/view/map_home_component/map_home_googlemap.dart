import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:enitproject/app/screen/story/binding/story_binding.dart';
import 'package:enitproject/app/screen/story/controller/story_controller.dart';
import 'package:enitproject/app/screen/story/view/story_screen.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestButton extends StatelessWidget {   // 테스트용
  final dynamic test;
  const TestButton({required this.test,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: 1,child: Text('$test'));
  }
}


class CustomGoogleMap extends GetView<MapHomeController> {
  final MapCreatedCallback onMapCreated;
  final RxList circle;
  const CustomGoogleMap({required this.onMapCreated,required this.circle,Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final Set<Marker> markers = Set();
    Set<Marker> getmarkers() { //markers to place on map

      for(int i=0;i< StoryService.to.storyList.length;i++){  /// 핀 색 바꾸기
        if(MapHomeController.to.invisibleTableRowSwitchList1[i] == LIGHT_YELLOW_COLOR){
        markers.add(Marker(
          //add first marker
          markerId: MarkerId(StoryService.to.storyList[i].storyPlayListKey ??'123'),
          position: LatLng(StoryService.to.storyList[i].latitude ?? 0.0, StoryService.to.storyList[i].longitude ?? 0.0), //
          infoWindow: InfoWindow( //popup info
            title: StoryService.to.storyList[i].title,
            onTap: (){
              if(AuthService.to.userModel.value!.circleList.contains(StoryService.to.storyList[i].storyPlayListKey)) {
                Get.to(() => StoryScreen(storyIndex: i,), binding: StoryBinding(storyIndex: i,));
              }
            }// 타이틀만 보여 줄꺼면 잘보이게 꾸미기 필요
          ),
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        ));
        }else{
          markers.add(Marker(
            //add first marker
            markerId: MarkerId(StoryService.to.storyList[i].storyPlayListKey ??'123'),
            position: LatLng(StoryService.to.storyList[i].latitude ?? 0.0, StoryService.to.storyList[i].longitude ?? 0.0), //
            infoWindow: InfoWindow( //popup info
                title: StoryService.to.storyList[i].title,
                onTap: (){
                  if(AuthService.to.userModel.value!.circleList.contains(StoryService.to.storyList[i].storyPlayListKey)) {
                    Get.to(() => StoryScreen(storyIndex: i,), binding: StoryBinding(storyIndex: i,));
                  }
                }// 타이틀만 보여 줄꺼면 잘보이게 꾸미기 필요
            ),
            /// 수정필요 1
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), //Icon for Marker
          ));

        }

      }

      return markers;
    }

    final Set<Circle> circles = new Set();
    Set<Circle> getcircles() { //markers to place on map
      for(int i=0;i< StoryService.to.storyList.length;i++){
        circles.add(Circle( //add first marker
          circleId: CircleId(StoryService.to.storyList[i].storyPlayListKey ?? '123'), // 타이틀만 보여 줄꺼면 잘보이게 꾸미기 필요
          center: LatLng(StoryService.to.storyList[i].latitude ?? 0.0, StoryService.to.storyList[i].longitude ?? 0.0),
          radius: 40,
          strokeColor:circle[i],
          fillColor: circle[i].withOpacity(0.5),
          strokeWidth: 1,
        ), //Icon for Marker
        );
      }
      return circles;
    }

    final location = Geolocator.getCurrentPosition();
    double lat =  33.49766527106121;
    double lng =  126.53094118653355;
    final LatLng companyLatLng = LatLng(lat, lng);
    final CameraPosition initialPosition = CameraPosition(  //지도 위치 초기화 및 우리가 바라볼 곳
      target: companyLatLng,
      zoom: 15,
    );

    return Positioned(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: getcircles(),
        markers: getmarkers(),
        onMapCreated: onMapCreated,
          onCameraIdle: ()=>{
            controller.initSize.value = 1
          }

      ),
    );
  }
}