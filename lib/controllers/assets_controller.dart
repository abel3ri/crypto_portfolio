import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_state_mgmt/models/api_response.dart';
import 'package:getx_state_mgmt/models/coin_data.dart';
import 'package:getx_state_mgmt/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tracked_asset.dart';

class AssetsController extends GetxController {
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
    _loadTrackedAssetsFromStorage();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HTTPService httpService = Get.find<HTTPService>();
    var responseData = await httpService.get(path: "currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(
      responseData,
    );

    coinData.value = currenciesListAPIResponse.data ?? [];
    loading.value = false;
  }

  void addTrackedAsset({
    required String name,
    required double amount,
  }) async {
    trackedAssets.add(
      TrackedAsset(
        name: name,
        amount: amount,
      ),
    );

    List<String> data =
        trackedAssets.map((asset) => jsonEncode(asset)).toList();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("_trackedAsset", data);
  }

  Future<void> _loadTrackedAssetsFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList("_trackedAsset");

    if (data != null) {
      trackedAssets.value = data.map((asset) {
        return TrackedAsset.fromJson(jsonDecode(asset));
      }).toList();
    }
  }

  double getPortfolioValue() {
    if (coinData.isEmpty) {
      return 0;
    }
    if (trackedAssets.isEmpty) {
      return 0;
    }
    double value = 0;
    for (var asset in trackedAssets) {
      value += getAssetPrice(name: asset.name!) * asset.amount!;
    }

    return value;
  }

  double getAssetPrice({required String name}) {
    double? assetPrice =
        getCoinData(name: name)?.values?.uSD?.price?.toDouble() ?? 0;
    return assetPrice;
  }

  CoinData? getCoinData({required String name}) {
    return coinData.firstWhereOrNull((coinData) {
      return coinData.name == name;
    });
  }
}
