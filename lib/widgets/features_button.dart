import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/services/http_service.dart';
import 'package:intl/intl.dart';

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

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HttpService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    print(responseData);
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
  final FeatureDialogController controller =
      Get.find(); // Use the controller instance properly

  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AlertDialog(
        title: Text(widget.mode),
        content: contentColumn(),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Add your action here
              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget contentColumn() {
    return controller.loading.isTrue
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Amount",
                  suffixIcon: Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  hintText: selectedDate != null
                      ? DateFormat('dd MMMM yyyy').format(selectedDate!)
                      : "Select Date",
                  suffixIcon: const Icon(Icons.date_range),
                ),
              ),
            ],
          );
  }
}

void showFeatureDialog(String mode) {
  Get.put(
      FeatureDialogController()); // Instantiate the controller when the dialog is shown
  Get.dialog(FeatureDialog(mode: mode));
}
