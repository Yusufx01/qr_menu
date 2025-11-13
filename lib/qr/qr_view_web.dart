import 'package:flutter/material.dart';

typedef PlatformQRViewController = dynamic;
typedef PlatformQRViewCreatedCallback = void Function(dynamic controller);

class PlatformQRView extends StatelessWidget {
  final GlobalKey qrKey;
  final PlatformQRViewCreatedCallback onQRViewCreated;

  const PlatformQRView({required this.qrKey, required this.onQRViewCreated, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('QR tarama webde desteklenmiyor'),
    );
  }
}
