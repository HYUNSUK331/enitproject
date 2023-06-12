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

import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/root/controller/root_controller.dart';
import 'package:enitproject/app/screen/splash_screen.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:enitproject/service/splash_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootView extends GetView<RootController> {
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        return FutureBuilder(
            future: SplashService.to.init(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                return Scaffold(
                  body: GetRouterOutlet(
                    initialRoute: AuthService.to.isLoggedIn.value //&& AuthService.to.userModel.value!=null
                        ? Routes.TAB
                        : Routes.LOGIN,
                  ),
                );
              }
              return const SplashScreen();
            });
      },
    );
  }
}
