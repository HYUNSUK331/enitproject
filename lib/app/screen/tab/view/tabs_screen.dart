import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/tab/controller/tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/icon/home_line.svg'),
                    activeIcon: SvgPicture.asset('assets/icon/home.svg'),
                    label: 'HOME',),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icon/board_line.svg'),
                      activeIcon: SvgPicture.asset('assets/icon/board.svg'), /// 수정필요 2 일단은 목록 이이콘 필요 추후 검색으로 변경
                      label: '이야기 목록'),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icon/heart_black_line.svg'),
                      activeIcon: SvgPicture.asset('assets/icon/heart_black.svg'),
                      label: 'LIKE'),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icon/mypage_line.svg'),
                      activeIcon: SvgPicture.asset('assets/icon/mypage.svg'),
                      label: 'MY'),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
