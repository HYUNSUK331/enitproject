import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/tab/controller/tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabsView extends GetView<TabsController> {
  const TabsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        //This router outlet handles the appbar and the bottom navigation bar
        controller.checkCurrentLocation(currentRoute);
        return Obx(() => Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              body: GetRouterOutlet(
                initialRoute: Routes.HOME,
                key: Get.nestedKey(Routes.TAB),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.selectIndex.value,
                backgroundColor: Colors.white,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.grey[850],
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
                onTap: (value) {
                  controller.onTap(value, delegate);
                },
                items: const [
                  BottomNavigationBarItem(
                    activeIcon:Icon(Icons.home, color: Colors.black87,),
                    icon: Icon(Icons.home, color: Colors.grey,),
                    label: '홈',),
                  BottomNavigationBarItem(
                      activeIcon:Icon(Icons.list_alt_outlined, color: Colors.black87,),
                      icon: Icon(Icons.list_alt_outlined, color: Colors.grey,),
                      label: '이야기 목록'),
                  BottomNavigationBarItem(
                      activeIcon:Icon(Icons.search, color: Colors.black87,),
                      icon: Icon(Icons.search, color: Colors.grey,), label: '이야기 검색'),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }

}


// class TabsView extends GetView<TabsController> {
//   const TabsView({Key? key}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Scaffold(
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             UserAccountsDrawerHeader(
//                 currentAccountPicture: CircleAvatar( // 메인 이미지
//                   backgroundImage: AssetImage('assets/story/pin.png'),
//                   backgroundColor: Colors.white,),
//                 accountName: Text("}"), accountEmail: Text("회원 이메일"),
//                 onDetailsPressed: () { // 어떻게 활용할지 찾아보기
//                   print('호랑이');},
//                 decoration: const BoxDecoration(  // 상단에 영역분리
//                     color: GREEN_DARK_COLOR,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(40.0),
//                       bottomRight: Radius.circular(40.0),
//                     ))
//
//             ),
//             ListTile(   // 분리된 구역 아래에 리스트형식으로 작성
//               leading: Icon(
//                 Icons.person_pin,
//                 color: Colors.grey[850],
//               ),
//               title: Text('My page'),
//               onTap: () {
//                 Get.to(() => MyPageView());
//               },
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.favorite,
//                 color: Colors.grey[850],
//               ),
//               title: Text('좋아요'),
//               onTap: () {
//                 Get.to(() => FavoriteListScreen());
//               },
//             ),
//             ListTile(
//               leading: Icon(
//                 Icons.mic,
//                 color: Colors.grey[850],
//               ),
//               title: Text('제보합니다'),
//               onTap: () {
//                 print('Q&A is clicked');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Stack(
//           children: [
//             IndexedStack(
//               index: controller.selecIndex.value,
//               children: [
//                 Navigator(
//                   onGenerateRoute: (routeSettings){
//                     return MaterialPageRoute(builder: (context) => const HomeView());
//                   },
//                 ),
//                 const PreviewScreen(),
//                 const MyPageView(),
//               ],
//             ),
//             Obx(()=> BottomPopupPlayerController.to.isPopup.value?
//             Positioned(
//                 bottom: 5, left: 10, right: 10,
//                 child: BottomPopupPlayer(storyIndex: storyIndex,)
//             )
//                 : SizedBox.shrink()),
//           ]
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//           currentIndex: controller.selecIndex.value,
//           elevation: 0.0,
//           onTap: controller.onTap,
//           selectedItemColor: Colors.grey,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black87,), label: '홈',),
//             BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined, color: Colors.black87,), label: '이야기 목록'),
//             BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.black87,), label: '이야기 검색'),
//           ]
//       ),
//     ));
//   }
// }

