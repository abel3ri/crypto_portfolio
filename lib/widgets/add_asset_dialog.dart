import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_state_mgmt/controllers/assets_controller.dart';
import 'package:getx_state_mgmt/models/api_response.dart';
import 'package:getx_state_mgmt/services/http_service.dart';

class AddAssetDialogController extends GetxController {
  RxBool loading = false.obs;
  RxList<String> assets = <String>[].obs;
  RxString selectedAsset = "".obs;
  RxDouble assetValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HTTPService httpService = Get.find<HTTPService>();
    dynamic responseData = await httpService.get(path: "currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);

    for (var el in currenciesListAPIResponse.data!) {
      assets.add(el.name!);
    }
    selectedAsset.value = assets.first;

    loading.value = false;
  }
}

class AddAssetDialog extends StatelessWidget {
  final controller = Get.put(AddAssetDialogController());

  AddAssetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Center(
          child: Material(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: _buildUI(context: context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUI({required BuildContext context}) {
    if (controller.loading.isTrue) {
      return const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          DropdownButton(
            value: controller.selectedAsset.value,
            items: controller.assets.map((asset) {
              return DropdownMenuItem(
                value: asset,
                child: Text(asset),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedAsset.value = value;
              }
            },
          ),
          TextField(
            onChanged: (value) {
              controller.assetValue.value = double.parse(value);
            },
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          FilledButton(
            onPressed: () {
              final assetsController = Get.find<AssetsController>();
              assetsController.addTrackedAsset(
                name: controller.selectedAsset.value,
                amount: controller.assetValue.value,
              );
              Get.back(closeOverlays: true);
            },
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
