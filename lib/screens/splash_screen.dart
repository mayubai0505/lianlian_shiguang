import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
// --- FIXED: Corrected the import paths to match your file structure ---
import 'onboarding_page.dart';
import 'main_page.dart'; // This should be your main page with the bottom navigation bar
import 'package:lianlian_shiguang/l10n/generated/app_localizations.dart';

// 啟動畫面,檢查是否為第一次啟動
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunch();
    });
  }

  Future<void> _checkFirstLaunch() async {
    print('SplashScreen: _checkFirstLaunch started.');
    try {
      // --- DEVELOPMENT MODE: The original logic is commented out below ---
      /*
      final prefs = await SharedPreferences.getInstance();
      bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      print('SplashScreen: isFirstLaunch = $isFirstLaunch');

      if (!mounted) {
        print('SplashScreen: Widget no longer mounted, aborting navigation.');
        return;
      }
      
      if (isFirstLaunch) {
        print('SplashScreen: First launch, navigating to OnboardingPage.');
        await prefs.setBool('isFirstLaunch', false);
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingPage()),
          );
        }
      } else {
        print('SplashScreen: Not first launch, navigating to MainPage.');
        await Future.delayed(const Duration(seconds: 2)); 
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
      */

      // --- DIRECT NAVIGATION: Skip onboarding and go straight to the main page ---
      print('SplashScreen: Development mode, skipping onboarding.');
      await Future.delayed(const Duration(
          seconds: 2)); // Keep the splash screen visible for a moment
      if (mounted) {
        Navigator.of(context).pushReplacement(
          // --- NOTE: Make sure 'MainPage' is the correct name for your main screen with the bottom navigation bar ---
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } catch (e) {
      print('Error in _checkFirstLaunch: $e');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const Scaffold(
                  body: Center(child: Text('Error loading app!')))),
        );
      }
    }
    print('SplashScreen: _checkFirstLaunch finished.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 255, 213, 227), Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  'assets/images/logo.jpg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading assets/logo.jpg: $error');
                    return const Icon(Icons.error,
                        size: 100, color: Colors.red);
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '戀戀拾光',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'love at first sight',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 255, 100, 150)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}