import 'package:enitproject/app/screen/map_home/controller/map_home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MapHomeController>(MapHomeController());
  }
}
