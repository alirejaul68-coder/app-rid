import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'driver_registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String _verificationId = '';
  bool _codeSent = false;
  bool _isLoading = false;

  // ওটিপি পাঠানোর ফাংশন
  Future<void> _verifyPhoneNumber() async {
    String phoneNumber = '+91${_phoneController.text.trim()}'; // ভারতের কোড অনুযায়ী
    
    if (_phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('দয়া করে সঠিক ১০ ডিজিটের মোবাইল নম্বর দিন')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // অটো-ভেরিফিকেশন হলে সরাসরি সাইন ইন হবে
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ভেরিফিকেশন ব্যর্থ হয়েছে: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ওটিপি (OTP) পাঠানো হয়েছে')),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // ওটিপি ভেরিফাই করে লগইন করার ফাংশন
  Future<void> _signInWithOTP() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text.trim(),
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      String uid = userCredential.user!.uid;
      String phone = _phoneController.text.trim();

      setState(() {
        _isLoading = false;
      });

      // সফলভাবে লগইন হওয়ার পর রেজিস্ট্রেশন স্ক্রিনে পাঠানো
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DriverRegistrationScreen(
            phoneNumber: phone,
            uid: uid,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ভুল ওটিপি দেওয়া হয়েছে: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toto Driver Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.electric_rickshaw, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            if (!_codeSent) ...[
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'মোবাইল নম্বর',
                  prefixText: '+91 ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _verifyPhoneNumber,
                      child: const Text('ওটিপি পাঠান'),
                    ),
            ] else ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ওটিপি (OTP) লিখুন',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signInWithOTP,
                      child: const Text('লগইন করুন'),
                    ),
            ],
          ],
        ),
      ),
    );
  }
}