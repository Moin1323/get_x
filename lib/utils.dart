import 'package:get/get.dart';
import 'package:getx/controllers/assets_controller.dart';
import 'package:getx/services/http_service.dart';

Future<void> registerServices() async {
  Get.put(
    HttpService(),
  );
}

Future<void> registerControllers() async {
  Get.put(
    AssetsController(),
  );
}
