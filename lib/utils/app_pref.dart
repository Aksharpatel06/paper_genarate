import 'package:shared_preferences/shared_preferences.dart';

class AppPref {
  static late final SharedPreferences _prefs;

  AppPref._privateConstructor();
  static final AppPref instance = AppPref._privateConstructor();

  /// Must be called before accessing prefs
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic Set
  Future<void> setValue(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Generic Get
  String? getValue(String key) {
    return _prefs.getString(key);
  }

  // Specific wrappers
  Future<void> setCategory(String value) => setValue('category', value);
  String? getCategory() => getValue('category');

  // Future<void> setBoard(String value) => setValue('board', value);
  // String? getBoard() => getValue('board');

  // Future<void> setMedium(String value) => setValue('medium', value);
  // String? getMedium() => getValue('medium');

  // Future<void> setStream(String value) => setValue('stream', value);
  // String? getStream() => getValue('stream');

  // Future<void> setStandard(String value) => setValue('standard', value);
  // String? getStandard() => getValue('standard');
}
