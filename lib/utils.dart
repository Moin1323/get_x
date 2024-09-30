import 'package:get/get.dart';
import 'package:getx/services/http_service.dart';

Future<void> registerServices() async {
  Get.put(
    HttpService(),
  );
}
