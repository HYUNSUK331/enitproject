import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool choolCheckDone = false;
  GoogleMapController? mapController;

  static final LatLng companyLatLng =
  LatLng(33.49766527106121, 126.53094118653355);    // 이게 이야기의 좌표!! 우리가 작성할 필요없고 DB에서 가져오는것

  static final CameraPosition initialPosition = CameraPosition(  //지도 위치 초기화 및 우리가 바라볼 곳
    target: companyLatLng,
    zoom: 15,
  );
  static final double okDistence = 50 ;     //원 사이즈 이거 const에 넣기

  static final Circle withinDistanceCircle = Circle(circleId: CircleId('withinDistanceCircle'),
    center: companyLatLng,                    // 이야기 1 좌표 DB에서 가져오기
    fillColor: Colors.blue.withOpacity(0.2),  // 진하기
    radius: okDistence,                         // 반지름
    strokeColor: Colors.blue,                 // 라인 색 const에넣어두기
    strokeWidth: 1,                           // 라인 두께
  );
  static final Circle notWithinDistanceCircle = Circle(circleId: CircleId('norWithinDistanceCircle'),
    center: companyLatLng,                    // 이야기 1 좌표 DB에서 가져오기
    fillColor: Colors.red.withOpacity(0.2),  // 진하기
    radius: okDistence,                         // 반지름
    strokeColor: Colors.red,                 // 라인 색 const에넣어두기
    strokeWidth: 1,                           // 라인 두께
  );
  static final Circle checkDoneCircle = Circle(circleId: CircleId('checkDoneCircle'),
    center: companyLatLng,                    // 이야기 1 좌표 DB에서 가져오기ㅠ
    fillColor: Colors.green.withOpacity(0.2),  // 진하기
    radius: okDistence,                         // 반지름
    strokeColor: Colors.green,                 // 라인 색 const에넣어두기
    strokeWidth: 1,                           // 라인 두께
  );





  static final Marker maker = Marker(
    markerId: MarkerId('marker'),
    position: companyLatLng,  //
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body:FutureBuilder(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.data == '위치 권한이 허가 되었습니다.') {
            return StreamBuilder<Position>(
                stream: Geolocator.getPositionStream(),
                builder: (context, snapshot) {
                  // print(snapshot.data); 위치 정보를 계속가져온다.
                  bool isWithinRange = false;   // 우리가 지정한 원안에 들어가있는지 아닌지 확인하는 bool

                  if(snapshot.hasData){
                    final start = snapshot.data!;
                    final end = companyLatLng;

                    final distance = Geolocator.distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude);
                    if(distance < okDistence){
                      isWithinRange = true;
                    }

                  }
                  return Column(
                    children: [
                      _CustomGoogleMap(initialPosition: initialPosition, circle: choolCheckDone ? checkDoneCircle: isWithinRange ? withinDistanceCircle : notWithinDistanceCircle ,onMapCreated: onMapCreated,marker: maker),
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

  onMapCreated(GoogleMapController controller){
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



class _CustomGoogleMap extends StatelessWidget {  // 구글맵  이거 따로 빼기
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
        markers: Set.from([marker]),
        onMapCreated: onMapCreated,
      ),
    );
  }
}