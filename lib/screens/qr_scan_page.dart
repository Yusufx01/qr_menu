import 'package:flutter/material.dart'; // Flutter'ın temel widget ve material bileşenleri
import '../qr/qr_view_wrapper.dart'; // Platforma özel QR view sarıcı (web/mobile ayrımı için)

class QRScanPage extends StatefulWidget { // QR tarama ekranı, durum (camera) yönetimi yapar
  const QRScanPage({super.key}); // Constructor

  @override
  State<QRScanPage> createState() => _QRScanPageState(); // State objesini oluştur
}

class _QRScanPageState extends State<QRScanPage> { // Ekranın stateful kısmı
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // QR view için benzersiz anahtar
  PlatformQRViewController? controller; // Platforma özel QR kontrolcüsü (kamera, stream vb.)

  @override
  void dispose() { // Widget kaldırılırken kaynakları temizle
    controller?.dispose(); // Kontrolcü varsa dispose et
    super.dispose(); // Üst sınıf dispose çağrısı
  }

  void _onQRViewCreated(PlatformQRViewController controller) { // QR view oluşturulduğunda çağrılır
    this.controller = controller; // Kontrolcüyü sakla
    // On web the controller is a stub; on mobile it provides scannedDataStream
    try {
      controller.scannedDataStream.listen((scanData) { // Tarama sonucu stream'ini dinle
        if (scanData.code == 'open_menu') { // Belirli bir kod geldiğinde menü aç
          controller.pauseCamera(); // Kamerayı durdur
          if (!mounted) return; // Widget hala ağaçta mı kontrol et
          Navigator.pushReplacementNamed(context, '/menu'); // Menü ekranına geç (test akışı)
        }
      });
    } catch (_) {
      // If running on web or stub, ignore stream handling.
    }
  }

  @override
  Widget build(BuildContext context) { // UI ağacını oluştur
    return Scaffold(
      appBar: AppBar(title: const Text('QR Kodu Tara')), // Basit bir app bar
      body: Column( // İki bölümden oluşan dikey düzen: kamera ve alt bilgi
        children: [
          Expanded(
            flex: 4, // Kamera alanı daha büyük
            child: PlatformQRView(
              qrKey: qrKey, // QR view anahtarı
              onQRViewCreated: _onQRViewCreated, // Oluştuğunda callback
            ),
          ),
          Expanded(
            flex: 1, // Alt bilgi alanı daha küçük
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // İçeriği ortala
                children: [
                  const Text('Menüyü görmek için QR kodu okutun'), // Kullanıcıya yönerge
                  const SizedBox(height: 8), // Boşluk
                  ElevatedButton(
                    onPressed: () { // Test amaçlı menüye geçiş butonu
                      Navigator.pushReplacementNamed(context, '/menu');
                    },
                    child: const Text('Menüyü Aç (test)'), // Buton metni
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
