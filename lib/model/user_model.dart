import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enitproject/const/const.dart';

class UserModel {
  String userKey;
  String email;
  String name;

  UserModel.fromMap(Map<String, dynamic> map, this.userKey)
      : email = map[KEY_USER_EMAIL],
        name = map[KEY_USER_NAME];

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data()! as Map<String, dynamic>, snapshot.id);
}
