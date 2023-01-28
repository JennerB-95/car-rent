import 'dart:convert';
import 'package:car_rental/models/equipment.dart';
import 'package:http/http.dart' as http;

class EquipmentService {
  static String url = 'http://api-apex.ceandb.com/getAll.php';
  static Future<List<Equipment>> fetchAll() async {
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode != 200) {
      throw response.body;
    }

    String responseUTF8 = utf8.decode(response.bodyBytes);
    List body = jsonDecode(responseUTF8);

    return body.map((app) => Equipment.fromJson(app)).toList();
  }
}
