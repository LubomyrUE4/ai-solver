import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StoreData {

  StoreData._privateConstructor();

  static final StoreData instance = StoreData._privateConstructor();

  Future<void> saveString(String key, String value) async {

    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      final encodedValue = base64.encode(utf8.encode(value));

      pref.setString(key, encodedValue);
    } catch (e){
      print('saveString ${e.toString()}');
    }

  }

  Future<String> getString(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final value = pref.getString(key) == null ? '' : pref.getString(key);
    if (value!.isNotEmpty) {
      final decodedValue = utf8.decode(base64.decode(value));
      return decodedValue.toString();
    }

    return '';
  }

  Future<bool> remove(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }

}