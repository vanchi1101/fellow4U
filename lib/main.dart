import 'package:flutter/material.dart';
import 'package:sign_up_in/page/navigationbar/mainnavigation.dart';
import 'package:sign_up_in/page/onboardings/onboarding_view.dart';
import 'package:sign_up_in/services/session_service.dart';

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
      home: FutureBuilder<bool>(
        future: SessionService.isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data ?? false) {
            return const MainNavigation();
          }

          return const OnboardingView();
        },
      ),
    );
  }
}
