import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static late SharedPreferences _preferences;
  static const _gettingNotifications = "getting_notifications";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setNotification(bool value) async {
    // String? searches = _preferences.getString(_themeMode) ?? "";
    await _preferences.setBool(_gettingNotifications, value);
  }

  static bool gettingNotification() =>
      _preferences.getBool(_gettingNotifications) ?? true;

  static deleteNotification() => _preferences.remove(_gettingNotifications);
}
