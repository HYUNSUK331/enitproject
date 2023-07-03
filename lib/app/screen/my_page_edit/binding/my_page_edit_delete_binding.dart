import 'package:enitproject/app/screen/my_page_edit/controller/my_page_edit_delete_controller.dart';
import 'package:get/get.dart';

class MyPageEditDeleteBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MyPageEditDeleteController>(MyPageEditDeleteController());
  }
}
