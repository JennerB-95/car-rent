import 'dart:convert';
import 'package:http/http.dart' as http; 
import '../models/user_model.dart';

class UserService {
  static String url = 'http://api-apex.ceandb.com/getUsers.php';
  static Future<List<User>> fetchAll() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw response.body;
    }
    String responseUTF8 = utf8.decode(response.bodyBytes);
    List body = jsonDecode(responseUTF8);
    return body.map((app) => User.fromJson(app)).toList();
  }
}
