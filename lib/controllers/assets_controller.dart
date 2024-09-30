import 'package:get/get.dart';
import 'package:getx/models/tracked_asset.dart';

class AssetsController extends GetxController {
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;
  @override
  void onInit() {
    super.onInit();
    print(trackedAssets);
  }

  void addTrackedAsset(String name, double amount) {
    trackedAssets.add(TrackedAsset(
      name: name,
      amount: amount,
    ));
    print(trackedAssets);
  }
}
