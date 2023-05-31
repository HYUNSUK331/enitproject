import 'package:enitproject/screen/map_home/map_home_controller.dart';
import 'package:enitproject/screen/mypage/mypage_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../const/const.dart';
import '../../screen/bottom_popup_player/bottom_popup_player_controller.dart';
import '../../screen/bottom_popup_player/bottom_popup_player_screen.dart';
import 'package:enitproject/screen/map_home/home_view.dart';
import 'package:flutter/material.dart';

import '../../screen/favorite/favorite_screen.dart';



class TabsView extends StatefulWidget {
  const TabsView({Key? key}) : super(key: key);

  @override  // 상속받은 메서드를 재저으이 할 때 사용
  State<TabsView> createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  int _selecIndex = 1;  // tap bar에서 선택하는 거 보여주기

  void _onTap(int index) {
    setState(() {
      _selecIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selecIndex,
            children: [
              const FavoriteScreen(),
              Navigator(
                onGenerateRoute: (routeSettings){
                  return MaterialPageRoute(builder: (context) => const HomeView());
                },
              ),
              const MyPageView(),
            ],
          ),
          Obx(()=> BottomPopupPlayerController.to.isPopup.value?
          Positioned(
              bottom: 5, left: 10, right: 10,
              child: BottomPopupPlayer(storyIndex: storyIndex,)
          )
              : SizedBox.shrink()),
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selecIndex,
        elevation: 0.0,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icon/heart_black_line.svg'),
              activeIcon: SvgPicture.asset('assets/icon/heart_black.svg'),
              label: 'LIKE'),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icon/home_line.svg'),
            activeIcon: SvgPicture.asset('assets/icon/home.svg'),
            label: 'HOME',),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icon/mypage_line.svg'),
              activeIcon: SvgPicture.asset('assets/icon/mypage.svg'),
              label: 'MY'),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black, unselectedFontSize: 13,
      ),
    );
  }
}
