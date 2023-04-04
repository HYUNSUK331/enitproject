import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';

class StoryListNetworkRepository {

//숨김이 아닌 플리 데이터 가져오기
  Future<List<StoryListModel>> getStoryListModel() async {
    final CollectionReference storyListCollRef = FirebaseFirestore.instance.collection(COLLECTION_STORYPLAYLIST);
    List<StoryListModel> resultList = [];
    QuerySnapshot querySnapshot = await storyListCollRef.get();
    querySnapshot.docs.forEach((element) {
      resultList.add(StoryListModel.fromSnapshot(element));
    });
    return resultList;
  }

  //좋아요 업데이트
  Future<String> updateStoryListLike(String storyListKey, bool isLike) async{
    final DocumentReference storyListCollRef = FirebaseFirestore.instance.collection(COLLECTION_STORYPLAYLIST).doc(storyListKey);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      tx.update(storyListCollRef, {KEY_LIKE: isLike});
    });
    return storyListKey;
  }

}

StoryListNetworkRepository storyListNetworkRepository = StoryListNetworkRepository();