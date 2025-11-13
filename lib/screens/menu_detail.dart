import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/menu_items.dart';

class MenuDetail extends StatefulWidget {
  final MenuItem item;

  const MenuDetail({super.key, required this.item});

  @override
  State<MenuDetail> createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  final ScrollController _scrollController = ScrollController();
  double _imageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    // gentle parallax: image moves up to 40 pixels as user scrolls
    setState(() => _imageOffset = (offset * 0.25).clamp(0.0, 40.0));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(item.name, style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 320,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Parallax hero image
                  Positioned(
                    top: -_imageOffset,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 380,
                      child: Hero(
                        tag: item.id,
                        child: Image.asset(
                          item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => Container(color: Colors.grey[300]),
                        ),
                      ),
                    ),
                  ),
                  // gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.45), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // blurred info chip
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 22,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          color: Colors.black.withOpacity(0.28),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(item.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.deepOrangeAccent.shade200]),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 6)],
                                ),
                                child: Text('${item.price.toStringAsFixed(0)} ₺', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800)),
                              ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Açıklama', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                  Row(
                    children: List.generate(5, (i) => Icon(Icons.star, size: 18, color: i < 4 ? Colors.amber : Colors.grey.shade400)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(item.description, style: GoogleFonts.poppins(fontSize: 14, height: 1.4)),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detaylar', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _infoChip(Icons.timer, 'Hazırlık', '10 dk'),
                      const SizedBox(width: 8),
                      _infoChip(Icons.local_fire_department, 'Kalori', '250 kcal'),
                      const SizedBox(width: 8),
                      _infoChip(Icons.restaurant, 'Porsiyon', '1 kişilik'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: Theme.of(context).colorScheme.primary),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Kapat'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
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

  Widget _infoChip(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
              Text(value, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
