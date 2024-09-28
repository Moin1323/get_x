import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.only(left: 12.0, right: 12, top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CurrentBalanceCard(
                      balance: 500000,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FeaturesButton(
                          text: "Add Earnings",
                          color: Color(0xFF757575), // Grey for buttons
                          icon: Icons.monetization_on,
                        ),
                        SizedBox(height: 16),
                        FeaturesButton(
                          text: "Add Expenses",
                          color: Color(0xFF616161), // Slightly darker grey
                          icon: Icons.money_off,
                        ),
                      ],
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
      height: 260,
      width: 180,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[800], // Darker grey for balance card background
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
            style: GoogleFonts.poppins(
              color: Colors.white, // White for text
              fontSize: 16,
            ),
          ),
          Text(
            "\$ $balance",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
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
      onTap: () {
        addDialogBox(context, text);
      },
      child: Container(
        height: 120,
        width: 120,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: color, // Custom grey shade for buttons
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

void addDialogBox(BuildContext context, String mode) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DialogContent(mode: mode);
    },
  );
}

class DialogContent extends StatefulWidget {
  final String mode;

  const DialogContent({super.key, required this.mode});

  @override
  DialogContentState createState() => DialogContentState();
}

class DialogContentState extends State<DialogContent> {
  String textField1Value = "";
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[300], // Light grey for dialog background
      title: Text(
        widget.mode,
        style: GoogleFonts.poppins(
          color: Colors.grey[800], // Darker grey for title text
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.attach_money),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.grey, // Border grey
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // Highlight blue for focus
                  ),
                ),
                filled: true,
                fillColor: Colors.white, // White background for TextField
                hintText: "Amount",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[600], // Lighter grey for hint text
                  fontSize: 14,
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                setState(() {
                  textField1Value = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              readOnly: true,
              onTap: () => _selectDate(context),
              controller: TextEditingController(
                text: selectedDate != null
                    ? DateFormat('dd MMMM yyyy').format(selectedDate!)
                    : '',
              ),
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.date_range),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[600]!, // Lighter grey border
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                fillColor: Colors.grey[200], // Light grey fill
                filled: true,
                hintText: "Date",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.unfold_more),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.grey, // Border grey
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // Border blue for focused state
                  ),
                ),
                filled: true,
                fillColor: Colors.white, // White fill for dropdown
                hintText: "Select Transaction",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[600], // Grey hint text
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            // Add logic for adding earnings/expenses here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: const Text("Save"),
        ),
      ],
    );
  }
}
