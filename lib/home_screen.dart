import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        title: const Text('টোটো ড্রাইভার ড্যাশবোর্ড'),
        backgroundColor: const Color(0xFF0A2E12),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ওয়ালেট ও পেমেন্ট পেজে যাওয়ার বাটন
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF161B22),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.amberAccent),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const Scaffold(
                          body: Center(child: Text('ওয়ালেট পেজ পাওয়া যায়নি')),
                        ),
                  ),
                );
              },
              icon: const Icon(
                Icons.account_balance_wallet,
                color: Colors.amberAccent,
              ),
              label: const Text(
                'ওয়ালেট ও ইউপিআই পেমেন্ট',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
