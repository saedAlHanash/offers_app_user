import 'package:shared_preferences/shared_preferences.dart';

class RecentSearch {
  static late SharedPreferences _preferences;
  static const _keyName = "recent_search";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setSearch(String query) async {
    List<String>? searches = _preferences.getStringList(_keyName) ?? [];
    if (!searches.contains(query)) {
      if (searches.length >= 10) {
        searches.removeAt(0);
      }
      searches.add(query);
    }
    await _preferences.setStringList(_keyName, searches);
  }

  static Future<bool> deleteSearchItem(
    int index,
  ) async {
    List<String>? searches = _preferences.getStringList(_keyName) ?? [];

    if (searches.isNotEmpty && index >= 0 && index < searches.length) {
      searches.removeAt(index);
      await _preferences.setStringList(_keyName, searches);
      return true;
    }
    return false;
  }

  static List<String>? getSearches() => _preferences.getStringList(_keyName);

  static deleteSearches() => _preferences.clear();
}
