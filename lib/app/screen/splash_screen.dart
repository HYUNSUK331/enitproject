
import 'package:flutter/material.dart';

/// 로딩화면
/// 여기는 무조건 들린다. 어차피 로딩되는 시간 짧아서 억지로 delay 시켜도 좋다.
class SplashScreen extends  StatelessWidget{
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
                backgroundColor: Colors.black,
                strokeWidth: 20.0,

            ),
          ],
        ),
      ),
    );
  }
}
