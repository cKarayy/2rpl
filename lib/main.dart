import 'package:flutter/material.dart';
import 'package:testt/landing.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BonTable',
      debugShowCheckedModeBanner: false,
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingScreen(),
        '/home': (context) =>  HomeScreen(),
        
      },
    );
  }
}
