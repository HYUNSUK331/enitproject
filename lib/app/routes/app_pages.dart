import 'package:enitproject/app/screen/favorite_list/binding/favorite_binding.dart';
import 'package:enitproject/app/screen/favorite_list/view/favorite_view.dart';
import 'package:enitproject/app/screen/login/bindings/login_binding.dart';
import 'package:enitproject/app/screen/login/view/login_view.dart';
import 'package:enitproject/app/screen/map_home/binding/home_binding.dart';
import 'package:enitproject/app/screen/map_home/view/home_view.dart';
import 'package:enitproject/app/screen/mypage/binding/mypage_binding.dart';
import 'package:enitproject/app/screen/mypage/view/mypage_screen.dart';
import 'package:enitproject/app/screen/preview/bindings/preview_binding.dart';
import 'package:enitproject/app/screen/preview/view/preview_screen.dart';
import 'package:enitproject/app/screen/root/bindings/root_binding.dart';
import 'package:enitproject/app/screen/root/view/root_screen.dart';
import 'package:enitproject/app/screen/signup/bindings/signup_binding.dart';
import 'package:enitproject/app/screen/signup/view/signup_view.dart';

import 'package:enitproject/app/screen/tab/binding/tabs_binding.dart';
import 'package:enitproject/app/screen/tab/view/tabs_screen.dart';
import 'package:get/get.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.TAB;

  static final routes = [
    GetPage(
      name: _Paths.ROOT,
      page: () => const RootView(),
      binding: RootBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      children: [
        GetPage(
          name: _Paths.LOGIN,
          page: () => const LoginView(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: _Paths.SIGN_UP,
          page: () => const SignupView(),
          binding: SignupBinding(),
        ),
        GetPage(
          preventDuplicates: true,
          name: _Paths.TAB,
          page: () => const TabsView(),
          bindings: [
            TabsBinding(),
          ],
          title: null,
          children: [
            ///홈
            GetPage(
              name: _Paths.Home,
              page: () => const HomeView(),
              title: 'Home',
              binding: HomeBinding(),
            ),

            ///좋아요 리스트 페이지
            GetPage(
              name: _Paths.FAVORITE,
              page: () => const FavoriteView(),
              title: 'Favorite',
              binding: FavoriteListBinding(),
            ),
            /// 이야기 목록
            GetPage(
              name: _Paths.STORYLIST,
              page: () => const PreviewScreen(),
              title: 'Storylist',
              binding: PreviewBinding(),
            ),
            /// 마이페이지
            GetPage(
              name: _Paths.MYPAGE,
              page: () => const MyPageView(),
              title: 'Community',
              binding: MyPageBinding(),
            ),
          ],
        ),
      ],
    ),
  ];
}
// middlewares: [
//   //only enter this route when authed
//   EnsureAuthMiddleware(),
// ],
