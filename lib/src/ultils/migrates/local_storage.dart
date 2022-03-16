import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final _local = LocalStorage._internal();
  late SharedPreferences _preferences;
  factory LocalStorage() {
    return _local;
  }
  LocalStorage._internal();

  Future<void> initial() async {
    try {
      _preferences = await SharedPreferences.getInstance();
    } catch (error) {
      debugPrint('[Local Storage]: $error');
    }
  }

  T? read<T>(String key) {
    return _preferences.get(key) as T?;
  }

  Future<void> write(String key, int value) async {
    try {
      final isSuccess = await _preferences.setInt(key, value);
      if (!isSuccess) {
        debugPrint("[Local Storage]: Can't set local");
      }
    } catch (error) {
      debugPrint('[Local Storage]: $error');
    }
  }

  Future<void> remove(String key, String value) async {
    try {
      final isSuccess = await _preferences.remove(key);
      if (!isSuccess) {
        debugPrint("[Local Storage]: Can't remove local");
      }
    } catch (error) {
      debugPrint('[Local Storage]: $error');
    }
  }
}
