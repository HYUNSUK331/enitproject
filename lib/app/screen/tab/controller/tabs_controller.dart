
import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/favorite_list/controller/favorite_controller.dart';
import 'package:get/get.dart';

class TabsController extends GetxController{
  RxInt selectIndex = RxInt(0);

  void onTap(int value, GetDelegate delegate) {  //여기서 인터넷 주소 형식으로 데이터 전송된다.
    switch (value) {
      case 0:
        delegate.toNamed(Routes.HOME);
        break;
      case 1:
        delegate.toNamed(Routes.STORYLIST);
        break;
      case 2:
        delegate.toNamed(Routes.FAVORITE);
        final FavoriteController favoriteListController = Get.find();
        favoriteListController.loadMore2();
        break;
      case 3:
        delegate.toNamed(Routes.MYPAGE);
        break;
      default:
    }
  }

  void checkCurrentLocation(GetNavConfig? currentRoute) {

    final currentLocation = currentRoute?.location;
    selectIndex.value = 0;

    if (currentLocation?.startsWith(Routes.STORYLIST) == true) {
      selectIndex.value = 1;
    }
    else if (currentLocation?.startsWith(Routes.FAVORITE) == true) {
      selectIndex.value = 2;
    }
    else if (currentLocation?.startsWith(Routes.MYPAGE) == true) {
      selectIndex.value = 3;
    }
  }
}