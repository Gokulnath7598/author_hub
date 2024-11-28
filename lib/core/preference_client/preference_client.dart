import 'package:shared_preferences/shared_preferences.dart';


class PreferencesClient {
  PreferencesClient({required this.prefs});

  final SharedPreferences prefs;

  //****************************** page-token **************************//
  Future<String?> getPageToken() async {
    final String? tokenString = prefs.getString('token');
    if (tokenString == null) {
      return null;
    }
    return tokenString;
  }

  void setUserPageToken({String? token}) {
    if (token == null) {
      prefs.setString('token', '');
      return;
    }
    prefs.setString('token', token);
  }
}
