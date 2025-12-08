import 'dart:ui'; // ImageFilter gibi grafik API'leri için

import 'package:flutter/material.dart'; // Material bileşenleri
import 'package:flutter/services.dart'; // Clipboard işlemleri için
import 'package:google_fonts/google_fonts.dart'; // Poppins fontu
import '../data/menu_items.dart'; // Menü öğesi modeli

class MenuDetail extends StatefulWidget { // Ürün detay ekranı
  final MenuItem item; // Gösterilecek Menü öğesi

  const MenuDetail({super.key, required this.item});

  @override
  State<MenuDetail> createState() => _MenuDetailState(); // State oluştur
}

class _MenuDetailState extends State<MenuDetail> { // Detay ekranının state'i
  final ScrollController _scrollController = ScrollController(); // Parallax ve kaydırma kontrolü
  double _imageOffset = 0.0; // Parallax için görüntü offset'i

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll); // Scroll dinleyicisini ekle
  }

  void _onScroll() { // Scroll gerçekleştiğinde parallax hesapla
    final offset = _scrollController.offset;
    // gentle parallax: image moves up to 40 pixels as user scrolls
    setState(() => _imageOffset = (offset * 0.25).clamp(0.0, 40.0)); // Offset'i sınırla
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Dinleyiciyi kaldır
    _scrollController.dispose(); // Controller'ı kapat
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item; // Kısa yol
    final textTheme = Theme.of(context).textTheme; // Temadan metin stillerini al

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Temadan arkaplan al
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparan appbar
        elevation: 0,
        title: Text(item.name, style: GoogleFonts.poppins()), // Ürün adı başlıkta
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Parallax için scroll controller
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailHeroHeader(item: item, imageOffset: _imageOffset), // Üstteki büyük görsel alanı
            const SizedBox(height: 16),
            _DetailDescription(item: item, textTheme: textTheme), // Açıklama bölümü
            const SizedBox(height: 16),
            _NutritionSection(calories: item.calories, textTheme: textTheme), // Besin bilgisi bölümü
            const SizedBox(height: 16),
            _DetailActions(item: item), // Aksiyon butonları
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DetailHeroHeader extends StatelessWidget { // Detay ekranının üst kısmındaki görsel alan
  final MenuItem item; // Gösterilecek ürün
  final double imageOffset; // Parallax için offset

  const _DetailHeroHeader({required this.item, required this.imageOffset});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -imageOffset,
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
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(0, 0, 0, 0.45), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 22,
            child: _GlassInfoBar(item: item),
          ),
        ],
      ),
    );
  }
}

class _GlassInfoBar extends StatelessWidget { // Görsel üzerindeki bulanık bilgi barı
  final MenuItem item;

  const _GlassInfoBar({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.all(14),
          color: const Color.fromRGBO(0, 0, 0, 0.28),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.deepOrangeAccent.shade200]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), blurRadius: 6)],
                ),
                child: Text(
                  '${item.price.toStringAsFixed(0)} ₺',
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailDescription extends StatelessWidget { // Açıklama bölümünü gösteren widget
  final MenuItem item;
  final TextTheme textTheme;

  const _DetailDescription({required this.item, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Açıklama', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              _InfoChip(icon: Icons.local_fire_department, title: 'Kalori', value: '${item.calories} kcal'),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.description, style: textTheme.bodyMedium?.copyWith(height: 1.4)),
        ],
      ),
    );
  }
}

class _NutritionSection extends StatelessWidget { // Besin bilgisi alanı
  final int calories;
  final TextTheme textTheme;

  const _NutritionSection({required this.calories, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detaylar', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(children: [_InfoChip(icon: Icons.local_fire_department, title: 'Kalori', value: '$calories kcal')]),
        ],
      ),
    );
  }
}

class _DetailActions extends StatelessWidget { // Alt butonlar
  final MenuItem item;

  const _DetailActions({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
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
    );
  }
}

class _InfoChip extends StatelessWidget { // Küçük bilgi etiketi
  final IconData icon; // Gösterilecek ikon
  final String title; // Üst satır
  final String value; // Alt satır

  const _InfoChip({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.06),
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
