import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx/models/api_response.dart';
import 'package:getx/models/coin_data.dart';
import 'package:getx/models/tracked_asset.dart';
import 'package:getx/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetsController extends GetxController {
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;
  @override
  void onInit() {
    super.onInit();
    _getAssets();
    _loadTrackedAssetsFromStorage();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HttpService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);

    coinData.value = currenciesListAPIResponse.data ?? [];

    loading.value = false;
  }

  void addTrackedAsset(String name, double amount) async {
    // Check if the asset already exists in the list
    int existingIndex = trackedAssets.indexWhere((asset) => asset.name == name);

    if (existingIndex != -1) {
      // If the asset exists, update the amount
      trackedAssets[existingIndex].amount =
          trackedAssets[existingIndex].amount! + amount;
      trackedAssets.refresh(); // Refresh to notify listeners
    } else {
      // If it doesn't exist, add it as a new asset
      trackedAssets.add(TrackedAsset(
        name: name,
        amount: amount,
      ));
    }

    // Save the updated list to SharedPreferences
    List<String> data =
        trackedAssets.map((asset) => jsonEncode(asset)).toList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("tracked_assets", data);

    // Trigger an update to the UI
    trackedAssets.refresh();
  }

  void removeTrackedAsset(TrackedAsset asset) async {
    // Step 1: Remove the asset from the trackedAssets list
    trackedAssets.remove(asset);

    // Step 2: Update SharedPreferences by removing the asset
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the stored tracked assets from SharedPreferences
    List<String> storedAssets = prefs.getStringList("tracked_assets") ?? [];

    // Find the corresponding asset in SharedPreferences and remove it
    storedAssets.removeWhere((item) {
      // Decode the stored item
      Map<String, dynamic> storedAsset = jsonDecode(item);

      // Match based on the asset's name or any other unique property
      return storedAsset["name"] == asset.name;
    });

    // Update SharedPreferences with the updated list
    await prefs.setStringList("tracked_assets", storedAssets);

    trackedAssets.refresh();
  }

  void _loadTrackedAssetsFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList("tracked_assets");
    if (data != null) {
      trackedAssets.value = data
          .map(
            (e) => TrackedAsset.fromJson(jsonDecode(e)),
          )
          .toList();
    }
  }

  double getTotalAssetValue() {
    if (coinData.isEmpty) {
      return 0.0;
    }
    if (trackedAssets.isEmpty) {
      return 0.0;
    }
    double value = 0;
    for (TrackedAsset asset in trackedAssets) {
      value += getAssetPrice(asset.name!) * asset.amount!;
    }
    return value;
  }

  double getAssetPrice(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull((e) => e.name == name);
  }

  // Method to get a TrackedAsset by name
  TrackedAsset getTrackedAssetByName(String name) {
    return trackedAssets.firstWhere((asset) => asset.name == name);
  }
}
