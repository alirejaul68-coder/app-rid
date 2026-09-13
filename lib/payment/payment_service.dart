import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PaymentService {
  static const String _historyKey = 'admin_user_payment_history';
  static const String _walletKey = 'wallet_balance';

  static Future<double> getWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_walletKey) ?? 250.0;
  }

  static Future<List<Map<String, String>>> getTransactionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? historyString = prefs.getString(_historyKey);
    if (historyString != null) {
      List decoded = jsonDecode(historyString);
      return decoded.map((e) => Map<String, String>.from(e)).toList();
    }
    return [];
  }

  static Future<double> processPayment(double amount, String txnId) async {
    final prefs = await SharedPreferences.getInstance();
    double currentBalance = prefs.getDouble(_walletKey) ?? 250.0;
    currentBalance += amount;
    await prefs.setDouble(_walletKey, currentBalance);

    List<Map<String, String>> history = await getTransactionHistory();
    String currentTime =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - ${DateTime.now().hour}:${DateTime.now().minute}";

    history.insert(0, {
      'amount': '₹ $amount',
      'txnId': txnId,
      'date': currentTime,
      'status': 'সফল (Success)',
    });

    await prefs.setString(_historyKey, jsonEncode(history));
    return currentBalance;
  }

  static void showAddMoneyModal(
    BuildContext context,
    Function(double newBalance) onUpdated,
  ) {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B2230),
          title: const Text(
            'ওয়ালেটে টাকা লোড করুন',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'টাকার পরিমাণ লিখুন (টাকা ডাইরেক্ট আপনার অ্যাকাউন্টে যাবে):',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'যেমন: ৫০০',
                    hintStyle: TextStyle(color: Colors.white38),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    if (amountController.text.isNotEmpty) {
                      double? amount = double.tryParse(amountController.text);
                      if (amount != null && amount > 0) {
                        Navigator.pop(context);
                        _showQrCodeScreen(context, amount, onUpdated);
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.greenAccent.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.greenAccent,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QR কোড ও UPI আইডি',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'স্ক্যান করে ডাইরেক্ট আপনার অ্যাকাউন্টে পাঠান',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'বাতিল',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showQrCodeScreen(
    BuildContext context,
    double amount,
    Function(double) onUpdated,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B2230),
          title: Text(
            '₹ $amount টাকার পেমেন্ট',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'এই কিউআর কোডে স্ক্যান করুন। টাকা সরাসরি আপনার পার্সোনাল অ্যাকাউন্টে ঢুকবে:',
                style: TextStyle(color: Colors.white70, fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.qr_code_2,
                  size: 130,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'আপনার ইউপিআই আইডি:',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.cyanAccent.withValues(alpha: 0.4)),
                ),
                child: const Text(
                  'yourname@ybl',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'বন্ধ করুন',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
              onPressed: () async {
                Navigator.pop(context);
                String txnId =
                    'TXN_ADMIN_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
                double newBal = await processPayment(amount, txnId);
                onUpdated(newBal);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'পেমেন্ট সফল! ₹ $amount আপনার অ্যাকাউন্টে জমা হয়েছে।',
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'টাকা দিয়েছি (সফল)',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showHistoryDialog(BuildContext context) async {
    List<Map<String, String>> history = await getTransactionHistory();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1B2230),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'সমস্ত পেমেন্টের ইতিহাস (Logs)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.receipt_long, color: Colors.cyanAccent),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: history.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'এখনও কোনো ট্রানজাকশন রেকর্ড নেই!',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        var txn = history[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161B22),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    txn['amount']!,
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    txn['status']!,
                                    style: const TextStyle(
                                      color: Colors.cyanAccent,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'আইডি: ${txn['txnId']}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                'সময়: ${txn['date']}',
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'বন্ধ করুন',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
