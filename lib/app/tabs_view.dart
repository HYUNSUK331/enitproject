
import 'package:enitproject/screen/favorite/favorite_view.dart';
import 'package:flutter/material.dart';

import '../screen/map/map_view.dart';


class TabsView extends StatefulWidget {
  const TabsView({Key? key}) : super(key: key);

  @override
  State<TabsView> createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {

  static List<Widget> pages = <Widget>[
    Navigator(
      onGenerateRoute: (routeSettings){
        return MaterialPageRoute(builder: (context) => const MapView());
      },
    )
  ];

  int _selecIndex = 0;

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
              Navigator(
                onGenerateRoute: (routeSettings){
                  return MaterialPageRoute(builder: (context) => const MapView());
                },
              )
            ],
          )
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
