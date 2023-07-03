import 'package:enitproject/app/screen/my_page_edit/controller/my_page_edit_delete_controller.dart';
import 'package:enitproject/app/screen/my_page_edit/controller/my_page_edit_update_controller.dart';
import 'package:get/get.dart';

class MyPageEditUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MyPageEditUpdateController>(MyPageEditUpdateController());
    Get.put<MyPageEditDeleteController>(MyPageEditDeleteController());
  }
}
