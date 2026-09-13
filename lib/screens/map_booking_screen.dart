import 'package:flutter/material.dart';
import 'dart:async';

class MapBookingScreen extends StatefulWidget {
  const MapBookingScreen({super.key});

  @override
  State<MapBookingScreen> createState() => _MapBookingScreenState();
}

class _MapBookingScreenState extends State<MapBookingScreen> {
  // লাইভ চলমান টোটো বা অটো বাইকের লিস্ট (যেখানে রিয়েল-টাইম সিট কাউন্ট থাকবে)
  final List<Map<String, dynamic>> _activeVehicles = [
    {'id': 'TOTO_01', 'vehicleName': 'টোটো - WB 74X', 'availableSeats': 2, 'top': 150.0, 'left': 100.0},
    {'id': 'AUTO_02', 'vehicleName': 'অটো - WB 74Y', 'availableSeats': 1, 'top': 300.0, 'left': 220.0},
    {'id': 'BIKE_03', 'vehicleName': 'বাইক ট্যাক্সি', 'availableSeats': 1, 'top': 450.0, 'left': 120.0},
  ];

  Timer? _moveTimer;

  @override
  void initState() {
    super.initState();
    _startSimulatedVehicleMovement(); // ম্যাপে গাড়িগুলোর লাইভ মুভমেন্ট সিমুলেট করার জন্য
  }

  // গাড়িগুলোর রিয়েল-টাইম মুভমেন্ট লজিক (জিপিএস ট্র্যাকিংয়ের আদলে)
  void _startSimulatedVehicleMovement() {
    _moveTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        for (var vehicle in _activeVehicles) {
          vehicle['top'] = (vehicle['top'] + 10) % 600;
          vehicle['left'] = (vehicle['left'] + 5) % 350;
        }
      });
    });
  }

  @override
  void dispose() {
    _moveTimer?.cancel();
    super.dispose();
  }

  // সরাসরি গাড়ি ট্যাপ করে বুক করার ফাংশন
  void _bookVehicle(Map<String, dynamic> vehicle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B2230),
          title: const Text('রাইড কনফার্ম করুন', style: TextStyle(color: Colors.white, fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('গাড়ি: ${vehicle['vehicleName']}', style: const TextStyle(color: Colors.cyanAccent, fontSize: 14)),
              const SizedBox(height: 6),
              Text('ফাঁকা সিট আছে: ${vehicle['availableSeats']} টি', style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('আপনি কি এই গাড়িটি এখনই বুক করতে চান?', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('না', style: TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (vehicle['availableSeats'] > 0) {
                    vehicle['availableSeats'] -= 1;
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${vehicle['vehicleName']} সফলভাবে বুক করা হয়েছে!')),
                );
              },
              child: const Text('বুক করুন', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('লাইভ রুট ও টোটো বুকিং ম্যাপ', style: TextStyle(color: Colors.cyanAccent, fontSize: 16)),
      ),
      body: Stack(
        children: [
          // কাস্টম রুট ম্যাপ ইন্টারফেস
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF111721),
              border: Border.all(color: Colors.white12),
            ),
            child: const Center(
              child: Text(
                '📍 [ ম্যাপ এরিয়া: পিকআপ পয়েন্ট থেকে ড্রপ পয়েন্ট ]',
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ),
          ),

          // লাইভ চলমান গাড়িগুলো এবং সিট কাউন্ট ব্যালুন
          for (var vehicle in _activeVehicles)
            Positioned(
              top: vehicle['top'],
              left: vehicle['left'],
              child: GestureDetector(
                onTap: () => _bookVehicle(vehicle), // গাড়িতে হাত দিলেই বুকিং পপআপ আসবে
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyanAccent, width: 1.5),
                    boxShadow: [
                      BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.3), blurRadius: 8),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.directions_car, color: Colors.greenAccent, size: 18),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vehicle['vehicleName'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text(
                            '${vehicle['availableSeats']} সিট খালি (ট্যাপ করুন)', 
                            style: const TextStyle(color: Colors.yellowAccent, fontSize: 9, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}