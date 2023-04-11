import 'package:enitproject/app/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/color.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: GREEN_DARK_COLOR,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
        home: TabsView()

    );
  }
}