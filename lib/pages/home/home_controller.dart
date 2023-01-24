import 'dart:convert';

import 'package:get/get.dart';

import '../../core.dart';
import "package:http/http.dart" as http;

class HomeController extends GetxController {
  static HomeController to = Get.find();
  User userProfile;
  List<Car> cars = [];
  List<Dealer> dealers = [];
  Car displayCar;
  List theData = [];

  @override
  void onInit() async {
    super.onInit();
    loadData();
    getData();
  }

  loadData() {
    userProfile = UserService().getProfile();
    cars = CarService().getCarList();
    dealers = DealerService().getDealerList();
    displayCar = cars[2];
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
