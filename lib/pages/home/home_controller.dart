import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core.dart';
import "package:http/http.dart" as http;

class HomeController extends GetxController {
  static HomeController to = Get.find();
 
  List<Car> cars = [];
  List<Dealer> dealers = [];
  Car displayCar;
  List theData = [];
  String uid,
      username,
      first_name,
      last_name,
      contact_number,
      emailU,
      dpiPasaporte,
      licencia,
      tipoLicencia,
      nit;

  @override
  void onInit() async {
    Get.delete();
    Get.put(HomeController());
    loadData();
    getData();
    getUserData();
    super.onInit();
  }

  loadData() {
    cars = CarService().getCarList();
    dealers = DealerService().getDealerList();
    displayCar = cars[2];
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("user_id");
    username = prefs.getString("username");
    first_name = prefs.getString("first_name");
    last_name = prefs.getString("last_name");
    contact_number = prefs.getString("contact_number");
    emailU = prefs.getString("email");
    dpiPasaporte = prefs.getString("dpiPasaporte");
    licencia = prefs.getString("licencia");
    tipoLicencia = prefs.getString("tipoLicencia");
    nit = prefs.getString("nit");

    print(
        " user data $uid $username $first_name $last_name $contact_number $emailU $dpiPasaporte $licencia $tipoLicencia $nit");
  }

  Future getData() async {
    String key = "api-apex";
    String fileName = "getAll.php";
    String url = "http://" + key + ".ceandb.com/" + fileName;
    http.Response response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    theData = data;
    print("the data $theData");
    return data;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
