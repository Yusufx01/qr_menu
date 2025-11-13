import 'package:flutter/material.dart';
import 'screens/qr_scan_page.dart';
import 'screens/menu_page.dart';

void main() {
  runApp(const SmartMenuApp());
}

class SmartMenuApp extends StatelessWidget {
  const SmartMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Menu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const QRScanPage(),
        '/menu': (context) => const MenuPage(),
      },
    );
  }
}
