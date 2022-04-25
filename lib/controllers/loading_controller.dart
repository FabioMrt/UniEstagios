import 'package:get/get.dart';

class LoadingController extends GetxController {
  var status = false.obs;

  on() {
    status.value = true;
  }

  out() {
    status.value = false;
  }
}
