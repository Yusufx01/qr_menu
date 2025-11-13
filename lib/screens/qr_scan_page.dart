import 'package:flutter/material.dart';
import '../qr/qr_view_wrapper.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  PlatformQRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(PlatformQRViewController controller) {
    this.controller = controller;
    // On web the controller is a stub; on mobile it provides scannedDataStream
    try {
      controller.scannedDataStream.listen((scanData) {
        if (scanData.code == 'open_menu') {
          controller.pauseCamera();
          Navigator.pushReplacementNamed(context, '/menu');
        }
      });
    } catch (_) {
      // If running on web or stub, ignore stream handling.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Kodu Tara')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: PlatformQRView(
              qrKey: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Menüyü görmek için QR kodu okutun'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/menu');
                    },
                    child: const Text('Menüyü Aç (test)'),
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
