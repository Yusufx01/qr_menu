import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // Professional, modern dark palette with warm accent
    final seed = const Color(0xFF6D4C41); // warm brown accent
    final darkBackground = const Color(0xFF0B1220); // deep blue-gray
    final surface = const Color.fromRGBO(255, 255, 255, 0.04);

    final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);

    final borderColor = const Color.fromRGBO(255, 255, 255, 0.06);

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBackground,
      cardColor: surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: colorScheme.primary,
        labelStyle: const TextStyle(color: Colors.white),
        secondaryLabelStyle: const TextStyle(color: Colors.white70),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Menu',
      theme: theme,
    
      // keep routes the same
      initialRoute: '/',
      routes: {
        '/': (context) => const QRScanPage(),
        '/menu': (context) => const MenuPage(),
        '/favorites': (context) => const FavoritesPage(),
      },
    );
  }
}
