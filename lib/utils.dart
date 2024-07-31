import 'package:get/get.dart';
import 'package:getx_state_mgmt/services/http_service.dart';

Future<void> registerServices() async {
  Get.put(HTTPService());
}
