import 'package:enitproject/model/storylist_model.dart';
import 'package:enitproject/repository/story_repository.dart';
import 'package:get/get.dart';

class StoryController extends GetxController{

  static StoryController get to => Get.find();

  RxList<StoryListModel> storyList = <StoryListModel>[].obs;

  @override
  void onInit() async{
    await storyRepository.getPlayListModel().then((value) => {
      storyList(value)
    });
    super.onInit();
  }
  @override
  void onReady() async{
    super.onReady();
  }
  @override
  void onClose() {
    super.onClose();
  }


}