import 'package:flutter/material.dart'; // Flutter'ın temel UI kütüphanesi
import 'package:provider/provider.dart'; // State yönetimi için Provider paketi
import 'package:google_fonts/google_fonts.dart'; // Özel font (Poppins) kullanmak için paket
import 'screens/qr_scan_page.dart'; // Uygulamanın QR tarama ekranı (route '/')
import 'screens/menu_page.dart'; // Menü listesinin bulunduğu ekran (route '/menu')
import 'screens/favorites_page.dart'; // Favoriler ekranı (route '/favorites')
import 'models/favorites_model.dart'; // Favorileri saklayan ve yöneten model
import 'data/menu_items.dart'; // Menü resimlerini önbelleğe almak için

Future<void> main() async { // Uygulama başlangıç noktası, async çünkü favorileri yükleyeceğiz
  WidgetsFlutterBinding.ensureInitialized(); // Flutter engine'i başlatmak/bağlamak için gerekli
  final favorites = FavoritesModel(); // Favoriler modelinden bir örnek oluştur
  await favorites.load(); // Kalıcı depolamadan (shared_preferences) favorileri yükle
  runApp( // Uygulamayı çalıştır ve widget ağacını başlat
    ChangeNotifierProvider.value( // Provider ile oluşturduğumuz modeli uygulama genelinde sağlar
      value: favorites, // Sağlanacak olan FavoritesModel örneği
      child: const SmartMenuApp(), // Root widget olarak SmartMenuApp'i başlat
    ),
  );
}

class SmartMenuApp extends StatefulWidget { // Stateful yaptık: arka plan animasyonu için state gerekiyor
  const SmartMenuApp({super.key}); // Constructor

  @override
  State<SmartMenuApp> createState() => _SmartMenuAppState();
}

class _SmartMenuAppState extends State<SmartMenuApp> with SingleTickerProviderStateMixin {
  late final AnimationController _bgController; // Arka plan animasyonu kontrolcüsü

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _bgController.repeat(reverse: true); // Sürekli ileri/geri animasyon

    // Post-frame: var olan resimleri önbelleğe alarak ilk görünümde oluşacak jank'i azalt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final item in menuItems) {
        precacheImage(AssetImage(item.image), context);
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { // Widget ağacını kuran build metodu
    // Professional, modern dark palette with warm accent
    const seed = Color(0xFF6D4C41); // Tema için kullanılacak ana renk (sıcak kahve tonu)
    const darkBackground = Color(0xFF0B1220); // Arka plan için derin mavi-gri
    const surface = Color.fromRGBO(255, 255, 255, 0.04); // Kart ve yüzeyler için hafif saydam beyaz

    final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark); // Renk paleti oluştur

    const borderColor = Color.fromRGBO(255, 255, 255, 0.06); // İnce sınır renkleri için kullan

    final theme = ThemeData( // Uygulama genel teması
      useMaterial3: true, // Material 3 stilini kullan
      colorScheme: colorScheme, // Daha önce oluşturulan renk şemasını uygula
      scaffoldBackgroundColor: Colors.transparent, // Arka planı transparan yap; global gradient gösterilecek
      cardColor: surface, // Kartların arka plan rengi
      cardTheme: CardThemeData( // Kartlara daha profesyonel görünüm ver
        color: surface,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shadowColor: colorScheme.primary.withAlpha((0.12 * 255).round()),
      ),
      pageTransitionsTheme: const PageTransitionsTheme( // Sayfa geçişlerini yumuşat
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme( // AppBar için özel tema
        backgroundColor: Colors.transparent, // AppBar'ı transparan yap
        elevation: 0, // Gölgeyi kaldır
        foregroundColor: Colors.white, // AppBar başlık rengi
        iconTheme: IconThemeData(color: Colors.white70), // AppBar ikon rengi
      ),
      textTheme: GoogleFonts.poppinsTextTheme(const TextTheme( // Metinlerde Poppins fontu kullan
        bodyLarge: TextStyle(color: Colors.white), // Büyük metinler beyaz
        bodyMedium: TextStyle(color: Colors.white70), // Orta metinler daha soluk beyaz
      )),
      elevatedButtonTheme: ElevatedButtonThemeData( // ElevatedButton için tema
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary, // Birincil renk arka plan
          foregroundColor: Colors.white, // Buton içi metin rengi
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Yuvarlatılmış köşeler
          padding: const EdgeInsets.symmetric(vertical: 14), // Dikey padding
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData( // OutlinedButton için tema
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white, // Metin rengi
          side: const BorderSide(color: borderColor), // Kenarlık rengi
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Köşe
          padding: const EdgeInsets.symmetric(vertical: 14), // Padding
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white70), // Genel ikon rengi
      chipTheme: ChipThemeData( // ChoiceChip/Chip için tema
        backgroundColor: surface, // Arkaplan
        selectedColor: colorScheme.primary, // Seçili chip rengi
        labelStyle: const TextStyle(color: Colors.white), // Etiket rengi
        secondaryLabelStyle: const TextStyle(color: Colors.white70), // İkincil etiket
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // İç boşluk
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Şekil
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity, // Platforma göre görsel yoğunluğu ayarla
    );

    return MaterialApp( // Uygulamayı başlatan MaterialApp widget'i
      debugShowCheckedModeBanner: false, // Debug etiketi kapat
      title: 'Smart Menu', // Uygulama başlığı (Android/iOS görev yöneticisinde)
      theme: theme, // Az önce oluşturduğumuz temayı ata

      // Global builder ile uygulama boyunca gösterilecek gradient arka plan ekle
      builder: (context, child) {
        // AnimatedBuilder yalnızca arka plan animasyonunu yeniden çizer; ana widget ağacını her frame
        // yeniden setState ile kırpmamak performans için daha iyidir.
        return AnimatedBuilder(
          animation: _bgController,
          builder: (context, _) {
            final t = _bgController.value; // 0..1 arası animasyon değeri
            final animatedColor = Color.lerp(darkBackground, colorScheme.primary, 0.14 + 0.06 * t) ?? darkBackground;
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-0.8, -1.0),
                  end: const Alignment(0.8, 1.0),
                  colors: [animatedColor, darkBackground],
                  stops: const [0.0, 1.0],
                ),
              ),
              child: child,
            );
          },
        );
      },

      // keep routes the same
      initialRoute: '/', // Başlangıç route'u
      routes: { // Uygulamadaki named route'lar
        '/': (context) => const QRScanPage(), // Ana ekran: QR tarama
        '/menu': (context) => const MenuPage(), // Menü ekranı
        '/favorites': (context) => const FavoritesPage(), // Favoriler ekranı
      },
    );
  }
}
