import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enitproject/const/const.dart';


/// 질문1. 여기서 리스트 String으로 바꾸면 DB에서 데이터 못가져와 전부 null된다. 왜 그런지 전혀 모르겠음...
class UserModel {
  String? userKey;
  String? email;
  String? name;
  String? phone_num;
  List<dynamic> favorite_list;  /// 여기 List안에 dynamic말고 String을 두면 DB와 연결이 안됬다.
  String? storyPlayListKey;

  UserModel.fromMap(Map<String, dynamic> map, this.userKey)
      : email = map[KEY_USER_EMAIL],
        name = map[KEY_USER_NAME],
        favorite_list = map[KEY_FAVORITE_LIST],
        phone_num = map[KEY_PHONE_NUM];

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data()! as Map<String, dynamic>, snapshot.id);
}
