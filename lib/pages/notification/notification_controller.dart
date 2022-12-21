import 'package:get/get.dart';

import '../../core.dart';

class NotificationController extends GetxController {
  List<NotificationMessage> messages = [];
  List<DateTime> messageDates = [];
  String title = "qwerty";

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  loadData() {
    messages = NotificationService().getMessageList();
    messageDates = NotificationService().getMessageDateList();
  }

  removeMessage(NotificationMessage item) {
    messages.remove(item);
    update();
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
