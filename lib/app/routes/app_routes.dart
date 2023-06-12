part of 'app_pages.dart';

abstract class Routes {
  /// 메인
  static const ROOT = _Paths.ROOT;

  /// 로그인
  static const LOGIN = _Paths.LOGIN;
  static const SIGN_UP = _Paths.SIGN_UP;

  /// 탭
  static const TAB = _Paths.TAB;

  /// 홈
  static const HOME = _Paths.TAB + _Paths.Home;

  ///이야기 페이지
  static const STORYLIST = _Paths.TAB + _Paths.STORYLIST;

  /// 좋아요 리스트 페이지
  static const FAVORITE = _Paths.TAB + _Paths.FAVORITE;

  /// 마이페이지
  static const MYPAGE = _Paths.TAB + _Paths.MYPAGE;

}

abstract class _Paths {
  static const ROOT = '/';
  static const LOGIN = '/login';
  static const SIGN_UP = '/sign_up';

  static const TAB = '/tab';
  static const Home = '/home';
  static const STORYLIST = '/storylist';
  static const FAVORITE = '/favorite';
  static const MYPAGE = '/mypage';
}
