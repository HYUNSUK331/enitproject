import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

const COLLECTION_STORYPLAYLIST = 'storyPlayList';
const KEY_ADDRESS_DETAIL = 'address_detail';
const KEY_ADDRESS_SEARCH = 'address_search';
const KEY_IMAGE = 'image';
const KEY_LIKE = 'like';
const KEY_MP3_PATH = 'mp3_path';
const KEY_PIN_ADDRESS = 'pin_address';
const KEY_SCRIPT = 'script';
const KEY_STORY_PLAY_LIST_KEY = 'story_play_list_key';
const KEY_TITLE = 'title';
const KEY_LATITUDE = 'latitude';
const KEY_LONGITUDE = 'longitude';
const KEY_CIRCLECOLOR = 'circlecolor';


const COLLECTION_USER = 'users';
const KEY_USER_KEY = 'userKey';
const KEY_USER_EMAIL = 'email';
const KEY_FAVORITE_LIST = "favorite_list";
const KEY_USER_NAME = 'name';
const KEY_PHONE_NUM = 'phone_num';
const KEY_CIRCLE_LIST = 'circle_list';

late int storyIndex;


void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 20.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

int latLnglistIndex = 0;