import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getx/widgets/features_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 12.0, right: 12, top: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CurrentBalanceCard(
                      balance: 500000,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              StreamBuilder<Object>(
                  stream: null,
                  builder: (context, snapshot) {
                    return TransactionList();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentBalanceCard extends StatelessWidget {
  final int balance;
  const CurrentBalanceCard({super.key, required this.balance});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 50),
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
                "$balance",
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

class TransactionList extends StatelessWidget {
  TransactionList({super.key});

  final String currentDate = DateFormat('EEEE, d MMMM').format(DateTime.now());
  void deleteFunction(BuildContext context) {}
  void editFunction(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            currentDate,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
