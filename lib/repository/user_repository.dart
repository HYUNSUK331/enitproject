import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enitproject/const/const.dart';
import 'package:enitproject/model/user_model.dart';

class UserRepository {
  /// 회원가입
  Future<UserModel?> attemptCreateUser(String userKey, String email, String name,String phoneNum) async {
    final DocumentReference userRef = FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userKey);
    DocumentSnapshot snapshot = await userRef.get();
    Map<String, dynamic> map ={
        KEY_USER_KEY:userKey,
        KEY_USER_EMAIL : email,
        KEY_USER_NAME : name,
        KEY_PHONE_NUM : phoneNum,
        KEY_FAVORITE_LIST : []};
    if (snapshot.exists) {
      UserModel userModel = UserModel.fromMap(map);
      return userModel;
    }
    else{
      await FirebaseFirestore.instance.runTransaction((tx) async {
        tx.set(userRef, map);
      });
      UserModel userModel = UserModel.fromMap(map);
      return userModel;
    }
  }

  /// 유저 불러오기
  Future<UserModel> getUserModel(String userKey) async {
    final DocumentReference userRef = FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userKey);
    DocumentSnapshot snapshot = await userRef.get();
    return UserModel.fromSnapshot(snapshot);
  }

  /// 좋아요 누르면 유저 favlist update하기 / 만들어 둔거
  Future<void>  updateFavList(list, String userKey) async {
    final DocumentReference userCollRef = FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userKey);
    await FirebaseFirestore.instance.runTransaction((tx) async {
      tx.update(userCollRef,{KEY_FAVORITE_LIST: list});
    });
  }

  /// 지울때는 쿼리...?
  /// 좋아요 누르면 유저 favlist update하기 / 만들어 둔거
  Future<void>  updateFavUnList(list, String userKey) async {
    final DocumentReference userCollRef = FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userKey);
    await FirebaseFirestore.instance.runTransaction((tx) async {
      tx.update(userCollRef,{KEY_FAVORITE_LIST: list});
    });
  }


  // 유저 프로필 이름 수정
  void updatePlayListTitle(String userKey, String name) {
    FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userKey).update({
      KEY_USER_NAME: name,
    });
  }
  // 유저 탈퇴
  Future<void> deleteUserModel(String userKey) async {
    await FirebaseFirestore.instance.collection(COLLECTION_USER).doc(userKey).delete();
  }

  // user 의 모든 내용 로컬로 가져오기
  Future<List<UserModel>> getUserListModel() async {
    final CollectionReference playListCollRef =
    FirebaseFirestore.instance.collection(COLLECTION_USER);
    List<UserModel> resultUserList = [];
    QuerySnapshot querySnapshot = await playListCollRef.get();

    querySnapshot.docs.forEach((element) {
      resultUserList.add(UserModel.fromSnapshot(element));
    });
    return resultUserList;
  }

}

UserRepository userRepository = UserRepository();
