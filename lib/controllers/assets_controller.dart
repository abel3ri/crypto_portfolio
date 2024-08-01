import 'package:get/get.dart';
import '../models/tracked_asset.dart';

class AssetsController extends GetxController {
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;

  @override
  void onInit() {
    super.onInit();
    print(trackedAssets);
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
}
