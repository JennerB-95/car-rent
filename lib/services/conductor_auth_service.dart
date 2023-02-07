import 'dart:convert';
import 'package:car_rental/models/conductor_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ConductorAuthService {
  static String url = 'http://api-apex.ceandb.com/conductorAuxList.php';
  static Future<List<ConductorAutorizado>> fetchAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user_id = prefs.getString("user_id");
    final response = await http.post(Uri.parse(url), body: {"id_user": "29"});
    if (response.statusCode != 200) {
      throw response.body;
    }
    String responseUTF8 = utf8.decode(response.bodyBytes);
    List body = jsonDecode(responseUTF8);
    return body.map((app) => ConductorAutorizado.fromJson(app)).toList();
  }
}
