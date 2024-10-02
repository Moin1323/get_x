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

String getCryptoImageUrl(String name) {
  // Remove spaces and convert the name to lowercase
  String formattedName = name.replaceAll(' ', '').toLowerCase();

  return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/$formattedName.png";
}
