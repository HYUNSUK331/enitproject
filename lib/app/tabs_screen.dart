import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../screen/bottom_popup_player/bottom_popup_player_controller.dart';
import '../screen/bottom_popup_player/bottom_popup_player_screen.dart';
import '../screen/preview/preview_controller.dart';
import '../screen/preview/preview_screen.dart';
import 'package:enitproject/screen/map_home/home_view.dart';
import 'package:flutter/material.dart';



class TabsView extends StatefulWidget {
  const TabsView({Key? key}) : super(key: key);

  @override
  State<TabsView> createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {

  //컨트롤러 사용을 위한 선언
  BottomPopupPlayerController bottomPopupPlayerController = Get.find();

  static List<Widget> pages = <Widget>[
    Navigator(
      onGenerateRoute: (routeSettings){

        return MaterialPageRoute(builder: (context) => const HomeView());  // class이름 MapHomeScreen 으로 변경하기

      },
    )
  ];

  int _selecIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selecIndex = index;

    });
  }

  late String storyKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selecIndex,
            children: [
              Navigator(
                onGenerateRoute: (routeSettings){
                  return MaterialPageRoute(builder: (context) => const HomeView());
                },
              ),
              PreviewScreen(),
            ],
          ),
          Obx(()=> bottomPopupPlayerController.isPopup.value?
          BottomPopupPlayer(storyKey: storyKey) : SizedBox.shrink()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selecIndex,
          elevation: 0.0,
          onTap: _onTap,
          selectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.favorite, color: Colors.black87,), label: '관심목록'),
            BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black87,), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.man, color: Colors.black87,), label: '마이페이지'),
          ]
      ),
    );
  }
}
