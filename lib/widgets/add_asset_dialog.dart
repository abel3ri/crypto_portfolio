import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_state_mgmt/services/http_service.dart';

class AddAssetDialogController extends GetxController {
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HTTPService httpService = Get.find<HTTPService>();
    dynamic data = await httpService.get(path: "currencies");
    print(data);
    loading.value = false;
  }
}

class AddAssetDialog extends StatelessWidget {
  final controller = Get.put(
    AddAssetDialogController(),
  );

  AddAssetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Material(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: _buildUI(),
          ),
        ),
      ),
    );
  }

  Widget _buildUI() {
    if (controller.loading.isTrue) {
      return Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Data loaded"),
      ],
    );
  }
}
