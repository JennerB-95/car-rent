import 'package:get/get.dart';
import '../core.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() { 
    Get.put<HomeController>(HomeController());
    Get.put<SearchController>(SearchController());
    Get.put<NotificationController>(NotificationController());
    Get.put<ProfileController>(ProfileController());
  }
}
