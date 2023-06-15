import 'package:enitproject/app/screen/mypage/controller/mypage_controller.dart';
import 'package:get/get.dart';

class MyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MyPageController>(MyPageController());
  }
}
