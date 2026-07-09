import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------- String ----------

  static Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // ---------- Int ----------

  static Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  // ---------- Double ----------

  static Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  static double getDouble(String key, {double defaultValue = 0}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  // ---------- Bool ----------

  static Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  // ---------- String List ----------

  static Future<bool> setStringList(
      String key,
      List<String> value,
      ) {
    return _prefs.setStringList(key, value);
  }

  static List<String> getStringList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  // ---------- JSON Object ----------

  static Future<bool> setJson(
      String key,
      Map<String, dynamic> json,
      ) {
    return _prefs.setString(key, jsonEncode(json));
  }

  static Map<String, dynamic> getJson(String key) {
    final value = _prefs.getString(key);

    if (value == null) {
      return {};
    }

    return Map<String, dynamic>.from(jsonDecode(value));
  }

  // ---------- JSON List ----------

  static Future<bool> setJsonList(
      String key,
      List<Map<String, dynamic>> list,
      ) {
    return _prefs.setString(
      key,
      jsonEncode(list),
    );
  }

  static List<Map<String, dynamic>> getJsonList(String key) {
    final value = _prefs.getString(key);

    if (value == null) return [];

    return (jsonDecode(value) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // ---------- Remove ----------

  static Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  static Future<bool> clear() {
    return _prefs.clear();
  }
}