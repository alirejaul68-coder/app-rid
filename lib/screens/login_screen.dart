import 'package:flutter/material.dart';
import 'driver_profile_screen.dart';
import 'driver_home_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;

  void _sendOtp() {
    if (_phoneController.text.length >= 10) {
      setState(() {
        _otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ওটিপি পাঠানো হয়েছে (ডেমো ওটিপি: 1234)'),
          backgroundColor: Colors.amber,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('দয়া করে সঠিক ১০ ডিজিটের মোবাইল নম্বর লিখুন!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text == '1234' || _otpController.text.length == 4) {
      // এখানে সুনির্দিষ্টভাবে চেক করা হচ্ছে:
      // ডেমোর জন্য যদি মোবাইল নম্বরের শেষ অঙ্ক '0' হয়, তবে তাকে নতুন ইউজার (New User) হিসেবে ধরা হবে।
      // অন্যথায় তাকে পুরাতন ইউজার (Old User) হিসেবে ধরা হবে।
      // (আপনি আপনার প্রয়োজনমতো এই কন্ডিশন পরিবর্তন করতে পারেন)
      bool isNewUser = _phoneController.text.endsWith('0');

      if (isNewUser) {
        // নতুন ইউজার হলে ডাইরেক্ট প্রোফাইল ও আধার/কেওয়াইসি পেজে যাবে
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DriverProfileScreen()),
        );
      } else {
        // পুরাতন ইউজার হলে সরাসরি ড্যাশবোর্ডে যাবে
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DriverHomeDashboard()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ভুল ওটিপি! সঠিক ৪ ডিজিটের ওটিপি দিন।'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A2E12),
              Color(0xFF38100A),
              Color(0xFF2E2B05),
              Color(0xFF090D16),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      size: 70,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'টোটো ড্রাইভার লগইন ও ওটিপি',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'আপনার মোবাইল নম্বর দিয়ে ভেরিফাই করুন',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    const SizedBox(height: 35),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'মোবাইল নম্বর',
                        labelStyle: const TextStyle(color: Colors.white60),
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.amberAccent,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.amberAccent,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF161B22),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!_otpSent)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _sendOtp,
                          child: const Text(
                            'ওটিপি পাঠান',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    if (_otpSent) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 12,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          labelText: '৪ ডিজিটের ওটিপি লিখুন',
                          labelStyle: const TextStyle(color: Colors.white60),
                          prefixIcon: const Icon(
                            Icons.security,
                            color: Colors.greenAccent,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.greenAccent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Colors.greenAccent,
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF161B22),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _verifyOtp,
                          child: const Text(
                            'ওটিপি যাচাই করুন ➔',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
