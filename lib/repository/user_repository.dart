import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enitproject/const/const.dart';
import 'package:enitproject/model/user_model.dart';

class UserRepository {

  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  /// 트랜잭션
  /// 회원가입
  ///
  Future<UserModel?> attemptCreateUser(String userKey, String email, String name) async {
    final DocumentReference userRef = _firebase.collection(COLLECTION_USER).doc(userKey);

    DocumentSnapshot snapshot = await userRef.get();
    Map<String, dynamic> map = {
      KEY_USER_KEY: userKey,
      KEY_USER_EMAIL: email,
      KEY_USER_NAME: name,
      KEY_FAVORITE_LIST: [],
      KEY_CIRCLE_LIST: []};
    if (snapshot.exists) {
      UserModel userModel = UserModel.fromMap(map);
      return userModel;
    }
      else {
        await _firebase.runTransaction((tx) async {
          tx.set(userRef, map);
        });
        UserModel userModel = UserModel.fromMap(map);
        return userModel;
      }
    }

    /// 트랜잭션
    /// 유저 불러오기
    Future<UserModel> getUserModel(String userKey) async {
      final DocumentReference userRef = _firebase.collection(
          COLLECTION_USER).doc(userKey);
      DocumentSnapshot snapshot = await userRef.get();
      return UserModel.fromSnapshot(snapshot);
    }

    /// 좋아요 누르면 유저 favlist update하기 / 만들어 둔거
    Future<void> updateFavList(list, String userKey) async {
      final DocumentReference userCollRef = _firebase
          .collection(COLLECTION_USER).doc(userKey);
      await _firebase.runTransaction((tx) async {
        tx.update(userCollRef, {KEY_FAVORITE_LIST: list});
      });
    }

    /// 지울때는 쿼리...?
    /// 좋아요 누르면 유저 favlist update하기 / 만들어 둔거
    Future<void> updateFavUnList(list, String userKey) async {
      final DocumentReference userCollRef = _firebase
          .collection(COLLECTION_USER).doc(userKey);
      await _firebase.runTransaction((tx) async {
        tx.update(userCollRef, {KEY_FAVORITE_LIST: list});
      });
    }


    /// 서클 리스트 변경
    Future<void> updateCircleColor2(list, String userKey) async {
      final DocumentReference storyListCollRef = _firebase
          .collection(COLLECTION_USER).doc(userKey);
      await _firebase.runTransaction((tx) async {
        tx.update(storyListCollRef, {KEY_CIRCLE_LIST: list});
      });
    }

    /// 트랜잭션
    // 유저 프로필 이름 수정
    void updatePlayListTitle(String userKey, String name) {
      _firebase.collection(COLLECTION_USER)
          .doc(userKey)
          .update({
        KEY_USER_NAME: name,
      });
    }

    /// 트랜잭션
    // 유저 탈퇴
    Future<void> deleteUserModel(String userKey) async {
      await _firebase.collection(COLLECTION_USER)
          .doc(userKey)
          .delete();
    }

    /// 트랜잭션
    /// 이렇게 사용하는게 맞나?
    // user 의 모든 내용 로컬로 가져오기
    Future<List<UserModel>> getUserListModel() async {
      List<UserModel> resultUserList = [];

    await _firebase.runTransaction((tx) async{
      final CollectionReference playListCollRef =
      _firebase.collection(COLLECTION_USER);
      QuerySnapshot querySnapshot = (await tx.get(playListCollRef as DocumentReference<Object?>)) as QuerySnapshot<Object?>;

      for (var element in querySnapshot.docs) {
        resultUserList.add(UserModel.fromSnapshot(element));
      }
    });
      return resultUserList;
    }

  }

UserRepository userRepository = UserRepository();