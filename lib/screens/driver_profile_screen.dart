import 'package:flutter/material.dart';
import 'driver_home_dashboard.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(
    text: 'সোনু মন্ডল',
  );
  final TextEditingController _vehicleController = TextEditingController(
    text: 'WB-25-TOTO',
  );
  bool _idUploaded = false;

  void _submitProfile() {
    if (_formKey.currentState!.validate() && _idUploaded) {
      // প্রোফাইল সেভ হওয়ার পর ড্যাশবোর্ডে রিডাইরেক্ট হবে
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DriverHomeDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('দয়া করে সমস্ত তথ্য দিন এবং আইডি কার্ড আপলোড করুন!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.badge_rounded,
                      size: 50,
                      color: Colors.amberAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'ড্রাইভার প্রোফাইল ও কেওয়াইসি সেটআপ',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'নতুন ইউজার রেজিস্ট্রেশন ফরম',
                      style: TextStyle(color: Colors.white60, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.amber,
                          child: Icon(
                            Icons.person,
                            size: 45,
                            color: Colors.black,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      'ড্রাইভারের পুরো নাম',
                      Icons.person,
                    ),
                    validator: (val) => val!.isEmpty ? 'নাম লিখুন' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _vehicleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      'টোটো রেজিস্ট্রেশন নম্বর',
                      Icons.directions_car,
                    ),
                    validator:
                        (val) => val!.isEmpty ? 'গাড়ির নম্বর লিখুন' : null,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.greenAccent.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.credit_card, color: Colors.amberAccent),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'আইডি কার্ড / আধার কার্ড',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'ফটো বা স্ক্যান কপি দিন',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _idUploaded
                                    ? Colors.greenAccent
                                    : Colors.amberAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              _idUploaded = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'আইডি কার্ড সফলভাবে আপলোড হয়েছে!',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            _idUploaded ? 'আপলোড সম্পন্ন' : 'আপলোড',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submitProfile,
                      child: const Text(
                        'সেভ করে ড্যাশবোর্ডে প্রবেশ করুন ➔',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      prefixIcon: Icon(icon, color: Colors.amberAccent),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.amberAccent, width: 1.5),
      ),
      filled: true,
      fillColor: const Color(0xFF161B22),
    );
  }
}
