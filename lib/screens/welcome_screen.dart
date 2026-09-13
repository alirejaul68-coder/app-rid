import 'dart:math';
import 'package:flutter/material.dart';
import '../../colors/app_colors.dart';
import 'driver_dashboard.dart';
import 'booking_dashboard.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int selectedTabIndex = 0; // 0 = Driver, 1 = Booking
  String selectedRole = 'BOYS'; 
  String userStatus = 'NEW'; 

  final TextEditingController inputController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(); 
  
  final TextEditingController otp1 = TextEditingController();
  final TextEditingController otp2 = TextEditingController();
  final TextEditingController otp3 = TextEditingController();
  final TextEditingController otp4 = TextEditingController();

  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  final FocusNode focus3 = FocusNode();
  final FocusNode focus4 = FocusNode();

  @override
  void initState() {
    super.initState();
    _generateAndAutoFillOtp();
  }

  void _generateAndAutoFillOtp() {
    String randomOtp = (1000 + Random().nextInt(9000)).toString();
    otp1.text = randomOtp[0];
    otp2.text = randomOtp[1];
    otp3.text = randomOtp[2];
    otp4.text = randomOtp[3];
  }

  @override
  void dispose() {
    inputController.dispose();
    passwordController.dispose();
    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();
    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    super.dispose();
  }

  void handleLoginOrSignup() {
    if (selectedTabIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DriverDashboard()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookingDashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.screen1BgTop, AppColors.screen1BgBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_taxi, color: AppColors.screen1Primary, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'WELCOME TO TOTO BOOKING APP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.screen1TextMain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'এন্টার ইওর ডিটেইলস টু স্টার্ট ইয়োর জার্নি',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTabIndex = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selectedTabIndex == 0 ? AppColors.screen1Primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Driver',
                                style: TextStyle(
                                  color: selectedTabIndex == 0 ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTabIndex = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selectedTabIndex == 1 ? AppColors.screen1Primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Booking',
                                style: TextStyle(
                                  color: selectedTabIndex == 1 ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'রেজিস্ট্রেশন ক্যাটাগরি',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => selectedRole = 'GIRLS'),
                        child: _RoleCard(title: 'GIRLS', icon: Icons.girl, isSelected: selectedRole == 'GIRLS'),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => selectedRole = 'BOYS'),
                        child: _RoleCard(title: 'BOYS', icon: Icons.boy, isSelected: selectedRole == 'BOYS'),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => selectedRole = 'OTHER'),
                        child: _RoleCard(title: 'OTHER', icon: Icons.group, isSelected: selectedRole == 'OTHER'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('মোবাইল নাম্বার অথবা ইমেইল আইডি লিখুন', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        TextField(
                          controller: inputController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '9876543210',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('৪ অঙ্কের পার্সোনাল পাসওয়ার্ড দিন', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: '****',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple.shade200),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Auto-filled OTP (ওটিপি)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple)),
                            GestureDetector(
                              onTap: _generateAndAutoFillOtp,
                              child: const Text('Resend', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildOtpDigitBox(otp1, focus1, focus2, null),
                            _buildOtpDigitBox(otp2, focus2, focus3, focus1),
                            _buildOtpDigitBox(otp3, focus3, focus4, focus2),
                            _buildOtpDigitBox(otp4, focus4, null, focus3),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => userStatus = 'NEW'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: userStatus == 'NEW' ? Colors.purple.shade700 : Colors.white,
                              border: Border.all(color: Colors.purple),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'NEW (নতুন)',
                              style: TextStyle(
                                color: userStatus == 'NEW' ? Colors.white : Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => userStatus = 'OLD'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: userStatus == 'OLD' ? Colors.purple.shade700 : Colors.white,
                              border: Border.all(color: Colors.purple),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'OLD (পুরাতন)',
                              style: TextStyle(
                                color: userStatus == 'OLD' ? Colors.white : Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade800,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: handleLoginOrSignup,
                      child: Text(
                        userStatus == 'NEW' ? 'Register & Continue' : 'Login with Password / OTP', 
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpDigitBox(
    TextEditingController controller,
    FocusNode currentFocus,
    FocusNode? nextFocus,
    FocusNode? prevFocus,
  ) {
    return SizedBox(
      width: 42,
      height: 38,
      child: TextField(
        controller: controller,
        focusNode: currentFocus,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.purple.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 6),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.purple.shade200)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocus != null) {
            nextFocus.requestFocus();
          } else if (value.isEmpty && prevFocus != null) {
            prevFocus.requestFocus();
          }
        },
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.title, required this.icon, required this.isSelected});
  final String title;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.purple.withValues(alpha: 0.15) : Colors.white,
        border: Border.all(color: isSelected ? Colors.purple : Colors.grey.shade300, width: isSelected ? 2 : 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: isSelected ? Colors.purple : Colors.brown),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isSelected ? Colors.purple : Colors.black87)),
        ],
      ),
    );
  }
}