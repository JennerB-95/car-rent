import 'package:get/get.dart';

import '../../core.dart';

class HomeController extends GetxController {
  static HomeController to = Get.find();
  User userProfile;
  List<Car> cars = [];
  List<Dealer> dealers = [];
  Car displayCar;

  @override
  void onInit() async {
    super.onInit();
    loadData();
  }

  loadData() {
    userProfile = UserService().getProfile();
    cars = CarService().getCarList();
    dealers = DealerService().getDealerList();
    displayCar = cars[2];
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
