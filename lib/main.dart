import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await SharedPref.isLoggedIn();
  runApp(MyApp(startAtLogin: !isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool startAtLogin;
  const MyApp({super.key, required this.startAtLogin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaundryKu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: startAtLogin ? const LoginScreen() : const HomeScreen(),
    );
  }
}
