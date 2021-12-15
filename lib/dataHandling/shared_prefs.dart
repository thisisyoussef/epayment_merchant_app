import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences _prefs;
  init() async {
    if (_prefs == null) {
      print("initiating prefs");
      _prefs = await SharedPreferences.getInstance();
    }
  }

  setId(String value) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString("id", value);
  }

  setIsolateName(String value) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString("isolateName", value);
  }

  getId() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('id');
  }

  getIsolateName() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('isolateName');
  }

  reload() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.reload();
  }
}
