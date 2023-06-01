import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:enitproject/app/screen/map_home/view/map_home_component/map_home_googlemap.dart';
import 'package:enitproject/app/screen/map_home/view/map_home_component/map_home_items.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


/// 처음 나오는 지도 화면
class HomeView extends GetView<MapHomeController> {
  const HomeView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
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
          /// 현재위치로 화면 이동
          IconButton(onPressed: ()async{
            if(controller.mapController == null){  // null 이면 return
              return;
            }
            final location = await Geolocator.getCurrentPosition();
            controller.mapController?.animateCamera(CameraUpdate.newLatLng(
              LatLng(location.latitude, location.longitude
              ),
            ),
            );
           print("^^^^^^^^^^^^^^^^^^^^^^^^^^${location.latitude},${location.latitude},$location^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
          },
            icon:const Icon(Icons.my_location, color: Colors.blue,),
          )
        ],
      ),
      /// 위치 권한 받기
      body: FutureBuilder(
        future: controller.checkPermission(), // 위치 권한 받아오기
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) { // 데이커를 다 받기전까지
            return const Center(
              child: CircularProgressIndicator(),  // 대기중 서클 띄워라
            );
          }

          if (snapshot.data == '위치 권한이 허가 되었습니다.') {
            return StreamBuilder<Position>(  // 데이터를 여러번 받아올때 사용
                stream: Geolocator.getPositionStream(),
                builder: (context, snapshot) {
                  controller.circleColorList(); // rxlist로 색이 담긴 리스트
                  ///핵심기능
                  ///서클 색 변경하고 알림띄우기
                  if(snapshot.hasData) controller.updateMarker(snapshot.data);
                  return Stack(
                      children: [
                        ///구글맵
                          CustomGoogleMap(
                              onMapCreated: controller.onMapCreated,
                              circle: controller.invisibleTableRowSwitchList1),// 서클 색 설정
                        ///이야기 리스트
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
  // Widget _buildContainer() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 20.0),
  //     height: 150.0,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: MapHomeController.to.latLngList.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return MapHomeItem(index: index);
  //       },
  //     ),
  //   );
  // }

  /// story list
  Widget _buildContainer2() {
    return Obx(() => DraggableScrollableSheet(  //obx 적용해서 불들어오면 바로바로 보이게 하기 / DraggableScrollableSheet -> 아래서 위로 끌어올리는 리스트
          maxChildSize: controller.initSize.value,
          initialChildSize: 0.3,  // 초기 사이즈
          builder: (context, sheetController) =>
              Container(  // DraggableScrollableSheet에 들어갈 리스트
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


  // handleTimeout(context) {  // 알림 띄우고 다시는 안 띄우는 함수 만들기
  //   showDialog(context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context){
  //         return AlertDialog(
  //           title: Text('플레이리스트 이름을 입력하세요'),
  //           content: Container(
  //             width: 200, height: 70, padding: EdgeInsets.all(10),
  //             child: Text("이야기를 확인하시겠습니까?"
  //             ),
  //           ),
  //           actions: [
  //             TextButton(onPressed: (){
  //               print("호랑이요@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
  //             }, child: Text('확인', style: TextStyle(fontSize: 15, color: Colors.deepPurple[800])))
  //           ],
  //         );
  //       });
  // }


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