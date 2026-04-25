import 'package:flutter/material.dart';
import 'package:sign_up_in/page/onboardings/onboarding_view.dart';

void main() {
  runApp(const MyApp());
} // dùng để render widget gốc

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingView(),
    );
  }
}
