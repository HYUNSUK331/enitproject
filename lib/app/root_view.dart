import 'package:enitproject/app/tabs_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
        ),
        home: TabsView()

    );
  }
}