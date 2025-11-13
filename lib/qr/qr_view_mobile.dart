import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

typedef PlatformQRViewController = QRViewController;
typedef PlatformQRViewCreatedCallback = void Function(QRViewController controller);

class PlatformQRView extends StatelessWidget {
  final GlobalKey qrKey;
  final PlatformQRViewCreatedCallback onQRViewCreated;

  const PlatformQRView({required this.qrKey, required this.onQRViewCreated, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QRView(key: qrKey, onQRViewCreated: onQRViewCreated);
  }
}
