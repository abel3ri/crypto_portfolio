import 'package:get/get.dart';
import 'package:getx_state_mgmt/models/api_response.dart';
import 'package:getx_state_mgmt/models/coin_data.dart';
import 'package:getx_state_mgmt/services/http_service.dart';
import '../models/tracked_asset.dart';

class AssetsController extends GetxController {
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
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

  void add({
    required String name,
    required double amount,
  }) {
    trackedAssets.add(
      TrackedAsset(
        name: name,
        amount: amount,
      ),
    );
  }

  double getPortfolioValue() {
    if (coinData.isEmpty) {
      return 0;
    }
    if (trackedAssets.isEmpty) {
      return 0;
    }
    double value = 0;
    trackedAssets.forEach((asset) {
      value += getAssetPrice(name: asset.name!) * asset.amount!;
    });

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
