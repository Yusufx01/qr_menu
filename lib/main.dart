import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/qr_scan_page.dart';
import 'screens/menu_page.dart';
import 'screens/favorites_page.dart';
import 'models/favorites_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favorites = FavoritesModel();
  await favorites.load();
  runApp(
    ChangeNotifierProvider.value(
      value: favorites,
      child: const SmartMenuApp(),
    ),
  );
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
        '/favorites': (context) => const FavoritesPage(),
      },
    );
  }
}
