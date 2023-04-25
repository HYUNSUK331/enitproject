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
    return GetMaterialApp(
        builder: EasyLoading.init(),
        home: FutureBuilder(
            future: SplashService.to.init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Scaffold(body: AuthService.to.isLoggedIn.value ? toTabsView() :toLoginView());
              }
              return const SplashScreen();
            }));
  }
  toTabsView(){
    Get.put<MapHomeController>(MapHomeController());
    return const TabsView();
  }
  toLoginView(){
    Get.put(LoginController());
    return const LoginView();
  }
}
