import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/controllers/assets_controller.dart';
import 'package:getx/models/coin_data.dart';
import 'package:getx/pages/coin_detail_page.dart';
import 'package:getx/utils.dart';
import 'package:getx/widgets/features_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  AssetsController assetsController = Get.find();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity + double.infinity,
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
        child: Obx(() => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, right: 12, top: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CurrentBalanceCard(
                          balance: assetsController
                              .getTotalAssetValue()
                              .toStringAsFixed(2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        // Pass assetsController to buildAssetList
                        return buildAssetList(context, assetsController);
                      }),
                ],
              ),
            )),
      ),
    );
  }
}

class CurrentBalanceCard extends StatelessWidget {
  final String balance;
  const CurrentBalanceCard({super.key, required this.balance});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      decoration: BoxDecoration(
        color: Colors.grey[800], // Darker grey for balance card background
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Account Value',
            style: GoogleFonts.poppins(
              color: Colors.white, // White for text
              fontSize: 20,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "\$ ",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                balance,
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const FeaturesButton(
            text: "Add",
            color: Color(0xFF757575), // Grey for buttons
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}

Widget buildAssetList(BuildContext context, AssetsController assetsController) {
  final String currentDate = DateFormat('EEEE, d MMMM').format(DateTime.now());

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF2D2D2D), // Darker Grey
            Color(0xFFBDBDBD), // Lighter Grey
            Color(0xFFFFFFFF), // White
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Text(
              currentDate,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.65,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: assetsController
                  .trackedAssets.length, // Use assetsController to get data
              itemBuilder: (context, index) {
                final asset = assetsController.trackedAssets[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoinDetailPage(
                            coinData:
                                CoinData()), // Pass the asset data to CoinDetailPage
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(
                              getCryptoImageUrl(
                                asset.name!,
                              ),
                            ),
                          )),
                    ),
                    title: Text(
                      asset.name ?? "",
                      style: GoogleFonts.poppins(
                        color: Colors.white, // White for text
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          "\$ ",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          assetsController
                              .getAssetPrice(asset.name!)
                              .toStringAsFixed(2),
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      asset.amount!.toStringAsFixed(1).toString(),
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    // Add other widgets based on your asset model
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
