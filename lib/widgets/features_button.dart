import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/controllers/assets_controller.dart';
import 'package:getx/models/api_response.dart';
import 'package:getx/services/http_service.dart';

class FeaturesButton extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const FeaturesButton({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showFeatureDialog(text),
      child: Container(
        width: 85,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 5),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureDialogController extends GetxController {
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
    HttpService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    currenciesListAPIResponse.data?.forEach(
      (coin) {
        assets.add(
          coin.name!,
        );
      },
    );
    selectedAsset.value = assets.first;
    loading.value = false;
  }
}

class FeatureDialog extends StatefulWidget {
  final String mode;

  const FeatureDialog({super.key, required this.mode});

  @override
  _FeatureDialogState createState() => _FeatureDialogState();
}

class _FeatureDialogState extends State<FeatureDialog> {
  final FeatureDialogController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.mode,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: contentColumn(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        AssetsController assetsController = Get.find();
                        assetsController.addTrackedAsset(
                          controller.selectedAsset.value,
                          controller.assetValue.value,
                        );
                        Get.back();
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget contentColumn(BuildContext contex) {
    return controller.loading.isTrue
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedAsset.value,
                  items: controller.assets.map((asset) {
                    return DropdownMenuItem<String>(
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
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    controller.assetValue.value = double.parse(value);
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Amount",
                  ),
                ),
              ],
            ),
          );
  }
}

void showFeatureDialog(String mode) {
  Get.put(
      FeatureDialogController()); // Instantiate the controller when the dialog is shown
  Get.dialog(FeatureDialog(mode: mode));
}
