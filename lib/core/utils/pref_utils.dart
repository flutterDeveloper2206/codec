//ignore: unused_import
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/login_screen/model/login_model.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _sharedPreferences;
    return prefs!.setString(key, value);
  }

  static String getString(String key, [String? defValue]) {
    return _sharedPreferences?.getString(key) ?? defValue ?? "";
  }


  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<bool>? remove(String key,) {
    return _sharedPreferences?.remove(key);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<bool?>? putObject(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs == null) return null;
    return prefs.setString(key, json.encode(value));
  }

  static Future<LoginModel?> getLoginModelData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? _data = prefs.getString(key);
    return (_data == null || _data.isEmpty)
        ? null
        : LoginModel.fromJson(jsonDecode(_data));
  }
}
