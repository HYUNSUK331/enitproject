import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enitproject/const/const.dart';

class StoryListModel{

  String? addressDetail;
  String? addressSearch;
  String? image;
  bool isLike = true;
  String? mp3Path;
  dynamic? pinAddress;
  String? script;
  String? storyPlayListKey;
  String? title;

  StoryListModel.fromMap(Map<String,dynamic>map)
      : addressDetail = map[KEY_ADDRESS_DETAIL],
        addressSearch = map[KEY_ADDRESS_SEARCH],
        image = map[KEY_IMAGE],
        isLike = map[KEY_LIKE],
        mp3Path = map[KEY_MP3_PATH],
        pinAddress = map[KEY_PIN_ADDRESS],
        script = map[KEY_SCRIPT],
        storyPlayListKey = map[KEY_STORY_PLAY_LIST_KEY],
        title = map[KEY_TITLE];



        StoryListModel.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data() as Map<String, dynamic>);
}