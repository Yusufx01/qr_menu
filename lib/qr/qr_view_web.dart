import 'package:flutter/material.dart'; // Temel widget kütüphanesi

typedef PlatformQRViewController = dynamic; // Web tarafında controller stub olarak dynamic tanımlandı
typedef PlatformQRViewCreatedCallback = void Function(dynamic controller); // Oluşturulma callback tipi

class PlatformQRView extends StatelessWidget { // Web için basit bir stub (kamera desteklenmiyor mesajı gösterir)
  final GlobalKey qrKey; // Anahtar (kullanılmıyor ama API uyumluluğu için tutulur)
  final PlatformQRViewCreatedCallback onQRViewCreated; // Oluşturulma callback'i (webde çağrılmayabilir)

  const PlatformQRView({required this.qrKey, required this.onQRViewCreated, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('QR tarama webde desteklenmiyor'), // Web platformu için bilgilendirici mesaj
    );
  }
}
