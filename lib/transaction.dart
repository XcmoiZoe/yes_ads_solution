import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_bottom_nav.dart';

class TransactionPage extends StatelessWidget {
  final String username;
  final String email; // ✅ Add this
  final int currentIndex;

  const TransactionPage({
    super.key,
    required this.username,
    required this.email, // ✅ Add this
    this.currentIndex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<double>> transactions = {
      'Yesterday': [12000, 32000, 67000],
      'Jul 5, 2025': [220000, 80000, 120000],
      'Jul 2, 2025': [400000, 154320000, 2450000],
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transaction History",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF5F5F5),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "As of July 2025",
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...transactions.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...entry.value.map((amount) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F1FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Good Life Coffee Advertisement",
                                        style: GoogleFonts.poppins(fontSize: 12),
                                      ),
                                      Text(
                                        amount.toStringAsFixed(2),
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }).toList(),

                      // Request Transactions Card
                      Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3CD),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.help_outline,
                                  color: Colors.deepOrangeAccent),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Request Transactions",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600)),
                                    Text("Requesting an outdated history.",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.black87)),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                ),
                                child: const Text("Request"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        username: username,
        email: email, // ✅ Fix: pass email here
        parentContext: context,
      ),
    );
  }
}
