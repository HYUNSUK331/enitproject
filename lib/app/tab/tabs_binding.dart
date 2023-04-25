import 'package:enitproject/screen/map_home/map_home_controller.dart';
import 'package:get/get.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MapHomeController>(MapHomeController());
  }
}
