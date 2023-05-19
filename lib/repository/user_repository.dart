import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enitproject/const/const.dart';
import 'package:enitproject/model/user_model.dart';

class UserRepository {
  /// 회원가입
  Future<void> attemptCreateUser(String userKey, String email, String name,String phoneNum) async {
    final DocumentReference userRef = FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userKey);
    DocumentSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      return await userRef.set({KEY_USER_KEY:userKey, KEY_USER_EMAIL : email, KEY_USER_NAME : name, KEY_PHONE_NUM : phoneNum});
    }
  }

  Future<void> googleAttemptCreateUser(String userKey, String email, String name,) async {
    final DocumentReference userRef = FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userKey);
    DocumentSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      return await userRef.set({KEY_USER_KEY:userKey, KEY_USER_EMAIL : email, KEY_USER_NAME : name});
    }
  }

  /// 유저 불러오기
  Future<UserModel> getUserModel(String userKey) async {
    final DocumentReference userRef = FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userKey);
    DocumentSnapshot snapshot = await userRef.get();
    return UserModel.fromSnapshot(snapshot);
  }




  // 유저 프로필 수정

  //탈퇴
}

UserRepository userRepository = UserRepository();
