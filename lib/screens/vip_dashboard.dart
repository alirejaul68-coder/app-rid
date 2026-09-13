import 'package:flutter/material.dart';

class VipDashboard extends StatelessWidget {
  const VipDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101726),
        title: const Text(
          '🌟 ভিআইপি ড্রাইভার ক্লাব ও অফার',
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ভিআইপি ওয়েলকাম ব্যানার
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B2F00), Color(0xFF1A1500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.5)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'এক্সক্লুসিভ ভিআইপি মেম্বারশিপ',
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'সার্বক্ষণিক ফ্রি সার্ভিস, টোটো ব্যাটারিতে বিশেষ ছাড় এবং ক্যাশব্যাক সুবিধা উপভোগ করুন।',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'আপনার জন্য বিশেষ অফারসমূহ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // অফার কার্ড ১
            _buildVipOfferCard(
              title: 'লিথিয়াম ব্যাটারি রিপ্লেসমেন্টে ১৫% ছাড়',
              subtitle:
                  'যেকোনো টোটোর ব্যাটারি পরিবর্তনে স্পেশাল ডিসকাউন্ট পাবেন।',
              icon: Icons.battery_charging_full,
            ),
            const SizedBox(height: 10),

            // অফার কার্ড ২
            _buildVipOfferCard(
              title: 'ফ্রি হাব মেশিন সার্ভিসিং',
              subtitle: 'মাসের প্রথম সপ্তাহে আপনার টোটোর হাব ও গেস ঝালাই ফ্রি।',
              icon: Icons.settings_suggest,
            ),
            const SizedBox(height: 10),

            // অফার কার্ড ৩
            _buildVipOfferCard(
              title: 'জিরো পার্সেন্ট কমিশন রাইড উইক',
              subtitle:
                  'এই সপ্তাহের সব রাইডের আয়ের পুরো টাকাটাই আপনার ওয়ালেটে যাবে।',
              icon: Icons.card_giftcard,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVipOfferCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101726),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amberAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.amberAccent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
