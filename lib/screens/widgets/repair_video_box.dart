import 'package:flutter/material.dart';

class RepairVideoBox extends StatelessWidget {
  final VoidCallback onTap;

  const RepairVideoBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2230),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.4)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library, color: Colors.purpleAccent, size: 24),
            SizedBox(height: 6),
            Text(
              'রিপেয়ার',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
            SizedBox(height: 2),
            Text(
              'ভিডিও',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
