import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/controllers/assets_controller.dart';
import 'package:getx/models/coin_data.dart';
import 'package:getx/models/tracked_asset.dart';
import 'package:getx/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CoinDetailPage extends StatelessWidget {
  final CoinData coinData; // This is the type of coin data passed to the page

  const CoinDetailPage({super.key, required this.coinData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2D2D2D), // Darker Grey
              Color(0xFFBDBDBD), // Lighter Grey
              Color(0xFFFFFFFF), // White
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Top Container for Image
              Container(
                padding: const EdgeInsets.only(top: 30),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      getCryptoImageUrl(coinData.name!),
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Call the removeTrackedAsset method from the controller
                          AssetsController assetsController = Get.find();

                          // Assuming there is a way to map or retrieve TrackedAsset from CoinData
                          TrackedAsset asset = assetsController
                              .getTrackedAssetByName(coinData.name!);

                          // Remove the asset
                          assetsController.removeTrackedAsset(asset);

                          // Navigate back after deletion
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Container for Coin Details
              Container(
                height: MediaQuery.sizeOf(context).height * 0.7,
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coinData.name!,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "\$ ",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              coinData.values!.uSD!.price!.toStringAsFixed(2),
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${coinData.values!.uSD!.percentChange24h!.toStringAsFixed(2)} % ",
                          style: GoogleFonts.poppins(
                            color: coinData.values!.uSD!.percentChange24h! > 0
                                ? Colors.green
                                : Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _assetInfo(context, coinData), // Pass coinData here

                    Text(
                      "Last Updated: ${DateFormat('EEEE, d MMMM').format(DateTime.now())}",
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pass coinData to _assetInfo
Widget _assetInfo(BuildContext context, CoinData coinData) {
  return Expanded(
    child: GridView(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
      ),
      children: [
        _infoCard(
          "Circulating Supply",
          coinData.circulatingSupply?.toStringAsFixed(2) ??
              'N/A', // Check for null
        ),
        _infoCard(
          "Maximum Supply",
          coinData.maxSupply?.toStringAsFixed(2) ?? 'N/A', // Check for null
        ),
        _infoCard(
          "Total Supply",
          coinData.totalSupply?.toStringAsFixed(0) ?? 'N/A', // Check for null
        ),

        // Add more cards as needed for other data points
      ],
    ),
  );
}

// Create the _infoCard widget to display information
Widget _infoCard(String title, String subTitle) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[800], // Dark grey background
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          title,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subTitle,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
