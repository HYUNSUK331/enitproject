import 'package:enitproject/app/screen/my_page_edit/controller/my_page_edit_update_controller.dart';
import 'package:enitproject/app/screen/mypage/controller/mypage_controller.dart';
import 'package:get/get.dart';

class MyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MyPageController>(MyPageController());
    Get.put<MyPageEditUpdateController>(MyPageEditUpdateController());
  }
}
