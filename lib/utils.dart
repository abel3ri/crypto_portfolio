import 'package:get/get.dart';
import 'package:getx_state_mgmt/controllers/assets_controller.dart';
import 'package:getx_state_mgmt/services/http_service.dart';

Future<void> registerServices() async {
  Get.put(HTTPService());
}

Future<void> registerControllers() async {
  Get.put(AssetsController());
}
