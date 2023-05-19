// import 'package:enitproject/app/tabs_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../const/color.dart';
//
// class RootView extends StatelessWidget {
//   const RootView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           scaffoldBackgroundColor: Colors.white,
//           primaryColor: GREEN_DARK_COLOR,
//           splashColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           hoverColor: Colors.transparent,
//           focusColor: Colors.transparent,
//         ),
//         home: TabsView()
//
//     );
//   }
// }
//
//

import 'package:enitproject/app/login/login_controller.dart';
import 'package:enitproject/app/login/login_view.dart';
import 'package:enitproject/app/splash_screen.dart';
import 'package:enitproject/app/tab/tabs_screen.dart';
import 'package:enitproject/screen/map_home/map_home_controller.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:enitproject/service/splash_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RootView extends StatelessWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp 에 Get 적용
    return GetMaterialApp(
        builder: EasyLoading.init(),
        home: FutureBuilder(
            future: SplashService.to.init(),  //SplashService의 init을 할 동안
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {  // 로딩이 끝나면
                return Scaffold(body: AuthService.to.isLoggedIn.value ? toTabsView() :toLoginView());  // isLoggedIn이 true라면(로그인이 되었다면) toTabsView 로 아니면 toLoginView로 이동
              }
              return const SplashScreen();   // 아직 완료가 안되었다면 로딩서클 보여줘라
            }
            ),
      theme: ThemeData(fontFamily: 'Pretendard'),
    );
  }
  toTabsView(){
    Get.put<MapHomeController>(MapHomeController()); // 들어가기전에 maphomecontroller 가져오기
    return const TabsView();
  }
  toLoginView(){
    Get.put(LoginController());   // 들어가기전에 logincontroller 가져오기
    return const LoginView();
  }
}
