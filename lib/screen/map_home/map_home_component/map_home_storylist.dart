//
// import 'package:flutter/material.dart';
//
// class MapHomeStoryList extends StatelessWidget {
//   const MapHomeStoryList({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placehol*--der();
//   }
// }
//
//
// class _buildContainer() {
//   return Align(
//     alignment: Alignment.bottomLeft,
//     child: Container(
//       margin: EdgeInsets.symmetric(vertical: 20.0),
//       height: 150.0,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: <Widget>[
//           for(int i = 0; i < MapHomeController.to.latLngList.length; i++ )
//             SizedBox(width: 10.0),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _boxes(
//                 "https://images.unsplash.com/photo-1504940892017-d23b9053d5d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
//                 33.49766527106121, 126.53094118653355,"Gramercy Tavern"),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
//
//
//
//
//
// Widget _boxes(String _image, double lat,double long,String restaurantName) {
//   return  GestureDetector(
//     onTap:()async{
//       if(controller.mapController == null){
//         return;
//       }
//       final location = await Geolocator.getCurrentPosition();
//
//       controller.mapController!.animateCamera(CameraUpdate.newLatLng(
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
//
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
//               Container(
//                 child: Icon(
//                   FontAwesomeIcons.solidStar,
//                   color: Colors.amber,
//                   size: 15.0,
//                 ),
//               ),
//               Container(
//                 child: Icon(
//                   FontAwesomeIcons.solidStar,
//                   color: Colors.amber,
//                   size: 15.0,
//                 ),
//               ),
//               Container(
//                 child: Icon(
//                   FontAwesomeIcons.solidStar,
//                   color: Colors.amber,
//                   size: 15.0,
//                 ),
//               ),
//               Container(
//                 child: Icon(
//                   FontAwesomeIcons.solidStar,
//                   color: Colors.amber,
//                   size: 15.0,
//                 ),
//               ),
//               Container(
//                 child: Icon(
//                   FontAwesomeIcons.solidStarHalf,
//                   color: Colors.amber,
//                   size: 15.0,
//                 ),
//               ),
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
//
//
//
