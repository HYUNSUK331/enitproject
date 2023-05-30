import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enitproject/const/const.dart';

class UserModel {
  String userKey;
  String email;
  String name;
  String phone_num;
  dynamic? favoritelist;


  UserModel.fromMap(Map<String, dynamic> map, this.userKey)
      : email = map[KEY_USER_EMAIL],
        name = map[KEY_USER_NAME],
        favoritelist = map[KEY_FAVORITE_LIST],
        phone_num = map[KEY_PHONE_NUM];

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data()! as Map<String, dynamic>, snapshot.id);
}
