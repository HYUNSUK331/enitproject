import 'package:enitproject/app/routes/app_pages.dart';
import 'package:enitproject/app/screen/my_page_edit/binding/my_page_edit_delete_binding.dart';
import 'package:enitproject/app/screen/my_page_edit/binding/my_page_edit_update_binding.dart';
import 'package:enitproject/app/screen/my_page_edit/view/my_page_edit_delete_view.dart';
import 'package:enitproject/app/screen/my_page_edit/view/my_page_edit_update_view.dart';
import 'package:enitproject/app/screen/mypage/controller/mypage_controller.dart';
import 'package:enitproject/app/screen/preview/bindings/preview_binding.dart';
import 'package:enitproject/app/screen/preview/view/all_preview_screen.dart';
import 'package:enitproject/const/color.dart';
import 'package:enitproject/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MyPageView extends GetView<MyPageController> {
  const MyPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "My page",
            style: TextStyle(color: Colors.black),
          )),
      body: SingleChildScrollView(

        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset('assets/mypage/proflie.jpg'),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Text("${AuthService.to.userModel.value!.name}님 반가워요",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              Text("${AuthService.to.userModel.value!.email}",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const MyPageEditUpdateView(),
                        binding: MyPageEditUpdateBinding());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: GREEN_BRIGHT_COLOR,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(
                    "수정",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenu(
                  title: "Settings",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {
                    Get.dialog(AlertDialog(
                      title: const Column(
                        children: <Widget>[
                          Text("Settings"), // 타이틀
                        ],
                      ),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "준비중 입니다.", // 메세지
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ));
                  }),
              const Divider(),
              const SizedBox(height: 15),
              ProfileMenu(
                  title: "About this app",
                  icon: LineAwesomeIcons.info,
                  onPress: () {
                    Get.dialog(AlertDialog(
                      iconColor: GREEN_MID_COLOR ,icon: Icon(Icons.icecream,size: 40),
                      title: const
                      Column(
                        children: <Widget>[
                              Text("JJurang",style: TextStyle(fontSize: 25)),
                           Text("1.0.00",style: TextStyle(fontSize: 15)),
                          Text("@2023",style: TextStyle(fontSize: 11))
                           // 타이틀
                        ],
                      ),
                      /// 이야기 담기
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "쮸랑은 제주의 숨은 이야기를 전하는", // 메세지
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ));
                  }),
              ProfileMenu(
                  title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    Get.dialog(AlertDialog(
                      title: const Column(
                        children: <Widget>[
                          Text("로그아웃"), // 타이틀
                        ],
                      ),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "정말 로그아웃 하시겠습니까?", // 메세지
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            AuthService.to.logout();
                            Get.rootDelegate.offAndToNamed(Routes.LOGIN);
                          },
                          child: const Text('예'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('아니요'),
                        ),
                      ],
                    ));
                  }),
              const Divider(),
              const SizedBox(height: 15),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const AllPreviewScreen(),
                        binding: PreviewBinding());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: GREEN_BRIGHT_COLOR,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(
                    "모든 이야기확인",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 15),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const MyPageEditDeleteView(),
                        binding: MyPageEditDeleteBinding());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(
                    "탈퇴",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  ///이런식으로 활용해도 stateless를 사용 하면 안되나?
  const ProfileMenu({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onPress;
  final Color? textColor;
  final bool endIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Icon(icon, color: GREEN_BRIGHT_COLOR),
      ),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodyMedium?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(LineAwesomeIcons.angle_right,
                  size: 18.0, color: Colors.grey),
            )
          : null,
    );
  }
}
