import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enitproject/model/storylist_model.dart';
import 'package:flutter/material.dart';

import '../const/const.dart';

class StoryListNetworkRepository {

  //전체 스토리 가져오기
  Future<List<StoryListModel>> getStoryListModel() async {
    final CollectionReference storyListCollRef = FirebaseFirestore.instance.collection(COLLECTION_STORYPLAYLIST);
    List<StoryListModel> resultList = [];
    QuerySnapshot querySnapshot = await storyListCollRef.get();
    for (var element in querySnapshot.docs) {
      resultList.add(StoryListModel.fromSnapshot(element));
    }
    return resultList;
  }

  //선택된 스토리 하나 가져오기
  Future<List<StoryListModel>> getStoryModel(String storyIDkey) async {
    final CollectionReference storyListCollRef = FirebaseFirestore.instance.collection(COLLECTION_STORYPLAYLIST);
    List<StoryListModel> resultList = [];
    QuerySnapshot querySnapshot = await storyListCollRef.where(KEY_STORY_PLAY_LIST_KEY, isEqualTo: storyIDkey).get();
    for (var element in querySnapshot.docs) {
      resultList.add(StoryListModel.fromSnapshot(element));
    }
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