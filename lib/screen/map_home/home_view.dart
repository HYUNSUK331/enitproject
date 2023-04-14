import 'package:badges/badges.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/screen/map_home/map_home_component/map_home_googlemap.dart';
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
    Get.put(MapHomeController()); // 페이지 마다 불러오기  두번 불러와도 가능한가?
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

                      if (distance < 40
                      ) {
                        invisibleTableRowSwitchList1[i] = GREEN_BRIGHT_COLOR;  //이 로직 돌아가는중에 오류
                        StoryController?.to.changeTrueBadgeColor(i);

                      }else{
                        invisibleTableRowSwitchList1[i] = LIGHT_YELLOW_COLOR;
                        StoryController?.to.changeFalseBadgeColor(i);
                      }
                    }
                  }
                  return Column(
                    children: [
                      CustomGoogleMap(onMapCreated: mapController.onMapCreated, circle: invisibleTableRowSwitchList1),  // 굳이 여기서 안 받아도 된다. 아래 class에서 해결하기
                      _buildContainer(),
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


 //###################################################################################3
  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: MapHomeController.to.latLngList.length,
          itemBuilder: (BuildContext context, int index) {
            return MapHomeItem(index: index);
          },
        ),
      ),
    );
  }







}

class MapHomeItem extends GetView<MapHomeController> {

  final int index;

  const MapHomeItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      SizedBox(width: 10.0),
      // for(int i = 0; i < MapHomeController.to.latLngList.length; i++)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _boxes(
            MapHomeController.to.latLngList[index].image.toString(),
            MapHomeController.to.latLngList[index].latitude!.toDouble(),
            MapHomeController.to.latLngList[index].longitude!.toDouble(),
            MapHomeController.to.latLngList[index].title.toString(),
          ),
        ),
    ],
    );
  }

  Widget _boxes(String _image, double lat, double long, String restaurantName) {
    return GestureDetector(
      onTap: () async {
        if (controller.mapController == null) {
          return;
        }
        controller.mapController!.animateCamera(
          CameraUpdate.newLatLng( // story 클릭 시 그 위치로 이동시키기
            LatLng(lat, long
            ),
          ),
        );
      },

      child: Container(
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
        Obx(() =>
        StoryController.to.storyList[index].changeStoryColor ==
            GREEN_BRIGHT_COLOR ?
        Badge(
          badgeStyle: BadgeStyle(
            badgeColor: GREEN_BRIGHT_COLOR,
          ),
          showBadge: true,

        )
            :
        Badge(
          badgeStyle: BadgeStyle(
            badgeColor: LIGHT_YELLOW_COLOR,
          ),
          showBadge: true,
        ),
        ),
        Text("${MapHomeController.to.latLngList.length}"),
        SizedBox(height: 5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
        SizedBox(height: 5.0),
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