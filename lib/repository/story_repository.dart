import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enitproject/const/const.dart';
import 'package:enitproject/model/storylist_model.dart';

class StoryRepository {

  Future<List<StoryListModel>> getPlayListModel() async {
    final CollectionReference playListCollRef =
        FirebaseFirestore.instance.collection(COLLECTION_STORYPLAYLIST);
    List<StoryListModel> resultStoryList = [];
    QuerySnapshot querySnapshot = await playListCollRef.get();

    for (var element in querySnapshot.docs) {
      resultStoryList.add(StoryListModel.fromSnapshot(element));
    }
    return resultStoryList;
  }

  //관심목록 데이터 가져오기
  Future<List<StoryListModel>> getFavStoryListListModel() async {
    final CollectionReference playListCollRef =
        FirebaseFirestore.instance.collection(COLLECTION_STORYPLAYLIST);
    List<StoryListModel> resultPlayList = [];
    QuerySnapshot querySnapshot = await playListCollRef.get();

    for (var element in querySnapshot.docs) {
      resultPlayList.add(StoryListModel.fromSnapshot(element));
    }
    return resultPlayList;
  }
}

StoryRepository storyRepository = StoryRepository();
