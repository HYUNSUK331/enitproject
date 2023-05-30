import 'package:enitproject/const/color.dart';
import 'package:enitproject/model/user_model.dart';
import 'package:enitproject/screen/favorite_list/favorite_list_screen.dart';
import 'package:enitproject/screen/mypage/mypage_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../const/const.dart';
import '../../screen/bottom_popup_player/bottom_popup_player_controller.dart';
import '../../screen/bottom_popup_player/bottom_popup_player_screen.dart';
import '../../screen/preview/preview_screen.dart';
import 'package:enitproject/screen/map_home/home_view.dart';
import 'package:flutter/material.dart';



class TabsView extends StatefulWidget {
  const TabsView({Key? key}) : super(key: key);

  @override  // 상속받은 메서드를 재저으이 할 때 사용
  State<TabsView> createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  int _selecIndex = 0;

  // intd(){
  //   if(Get.arguments == null){
  //   _selecIndex = 0;
  //   }else
  //     _selecIndex = Get.arguments;
  //   return _selecIndex;
  // }
  void _onTap(int index) {
    setState(() {
      _selecIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar( // 메인 이미지
                  backgroundImage: AssetImage('assets/story/pin.png'),
                  backgroundColor: Colors.white,),
                accountName: Text("}"), accountEmail: Text("회원 이메일"),
                onDetailsPressed: () { // 어떻게 활용할지 찾아보기
                  print('호랑이');},
                decoration: BoxDecoration(  // 상단에 영역분리
                    color: GREEN_DARK_COLOR,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ))

            ),
            ListTile(   // 분리된 구역 아래에 리스트형식으로 작성
              leading: Icon(
                Icons.person_pin,
                color: Colors.grey[850],
              ),
              title: Text('My page'),
              onTap: () {
                Get.to(() => MyPageView());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.favorite,
                color: Colors.grey[850],
              ),
              title: Text('좋아요'),
              onTap: () {
                Get.to(() => FavoriteListScreen());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.mic,
                color: Colors.grey[850],
              ),
              title: Text('제보합니다'),
              onTap: () {
                print('Q&A is clicked');
              },
            ),
          ],
        ),
      ),
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
              const PreviewScreen(),
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
          currentIndex: _selecIndex,
          elevation: 0.0,
          onTap: _onTap,
          selectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black87,), label: '홈',),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined, color: Colors.black87,), label: '이야기 목록'),
            BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.black87,), label: '이야기 검색'),
          ]
      ),
    );
  }
  // Widget drawerBar(String title) {
  //   return ListTile(
  //     leading: Icon(
  //       Icons.home,
  //       color: Colors.grey[850],
  //     ),
  //     title: Text(title),
  //     onTap: () {
  //       Get.to(() => MyPageView());
  //     },
  //   );
  // }
}

