import 'package:shared_preferences/shared_preferences.dart';

void updateMapLocalSave(List<String> string)async{
  SharedPreferences sp = await SharedPreferences.getInstance();


  await sp.setStringList('string', <String>['yellow', 'yellow', 'yellow']);
}