import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/phone_auth_screen.dart';
import 'screens/otp_verify_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/driver_dashboard.dart';

void main() {
  runApp(const TotoDriverApp());
}

class TotoDriverApp extends StatelessWidget {
  const TotoDriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toto Driver Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/phoneAuth': (context) => const PhoneAuthScreen(),
        '/otpVerify': (context) {
          final arguments =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return OtpVerifyScreen(
            verificationId: arguments['verificationId']!,
            phoneNumber: arguments['phoneNumber']!,
          );
        },
        '/welcome': (context) => const WelcomeScreen(),
        '/dashboard': (context) => const DriverDashboard(),
      },
    );
  }
}
