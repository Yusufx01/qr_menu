import 'package:flutter/widgets.dart'; // Düşük seviye widget'lar (bu dosyada sadece QRView kullanılıyor)
import 'package:qr_code_scanner/qr_code_scanner.dart'; // QR kod taramak için native paket

typedef PlatformQRViewController = QRViewController; // Mobilde kullanılan controller tipi
typedef PlatformQRViewCreatedCallback = void Function(QRViewController controller); // Oluşturulma callback tipi

class PlatformQRView extends StatelessWidget { // Mobil platform için gerçek QR view sarmalayıcı
  final GlobalKey qrKey; // QR view için anahtar
  final PlatformQRViewCreatedCallback onQRViewCreated; // Oluşturulduğunda çağrılacak callback

  const PlatformQRView({required this.qrKey, required this.onQRViewCreated, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QRView(key: qrKey, onQRViewCreated: onQRViewCreated); // Platformun gerçek QR view bileşeni
  }
}
