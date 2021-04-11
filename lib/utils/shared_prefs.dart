import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late SharedPreferences _prefs;

  Future initialise() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // device_token
  String? get deviceToken {
    return _prefs.getString("deviceToken");
  }

  set deviceToken(String? token) {
    _prefs.setString("deviceToken", token ?? "");
  }

  String? get prefixUrl {
    if (!_prefs.containsKey('prefix_url')) return null;

    return _prefs.getString('prefix_url');
  }

  String? get accessToken {
    if (!_prefs.containsKey('access_token')) return null;

    return _prefs.getString('access_token');
  }

  bool get isLogin => prefixUrl != null && accessToken != null;

  bool? get firstRun {
    if (!_prefs.containsKey('first_run')) {
      return true;
    }

    return _prefs.getBool('first_run');
  }

  set firstRun(bool? value) {
    _prefs.setBool('first_run', value ?? false);
  }

  void removeSeason() {
    _prefs.remove('access_token');
    _prefs.remove('prefix_url');
    _prefs.remove('profile');
  }
}
