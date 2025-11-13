import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/menu_items.dart';

class MenuDetail extends StatelessWidget {
  final MenuItem item;

  const MenuDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(item.name, style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: item.id,
                    child: Image.asset(
                      item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) => Container(color: Colors.grey[300]),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.35), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          color: Colors.black.withOpacity(0.25),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(item.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                              ),
                              Text('${item.price.toStringAsFixed(0)} ₺', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Açıklama', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(item.description, style: GoogleFonts.poppins(fontSize: 14)),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Kapat'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final text = '${item.name} - ${item.price.toStringAsFixed(0)} ₺\n${item.description}';
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ürün bilgisi kopyalandı')));
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Paylaş'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
