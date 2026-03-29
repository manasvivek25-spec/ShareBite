import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(ShareBiteApp());
}

class ShareBiteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShareBite',
      theme: ThemeData(
  scaffoldBackgroundColor: Colors.white,

  primaryColor: Color(0xFF2E7D32),

  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF2E7D32),
    elevation: 3,
  ),

  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF2E7D32),
    primary: Color(0xFF2E7D32),
    secondary: Color(0xFF1565C0),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1565C0),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),
),
      home: HomeScreen(),
    );
  }
}