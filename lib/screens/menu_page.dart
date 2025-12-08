import 'package:flutter/material.dart'; // Material widget'ları

import 'package:google_fonts/google_fonts.dart'; // Poppins fontu için paket
import 'package:provider/provider.dart'; // Provider ile state yönetimi
import '../data/menu_items.dart'; // Menü verileri
import '../models/favorites_model.dart'; // Favoriler modeline erişim
import 'menu_detail.dart'; // Menü detay ekranı

class MenuPage extends StatefulWidget { // Menü listesini gösteren ekran (filtreleme, arama)
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState(); // State oluştur
}

class _MenuPageState extends State<MenuPage> { // Menü ekranının state'i
  String selectedCategory = 'Tümü'; // Seçili kategori (varsayılan: tümü)
  String query = ''; // Arama sorgusu
  final Set<int> _visibleItems = {}; // Staggered görünüm için hangi öğelerin gösterildiğini tutar
  int _filterHash = 0; // Filtre değişikliklerini takip etmek için hash

  List<String> get categories { // Mevcut kategorileri hesapla
    final cats = menuItems.map((e) => e.category).toSet().toList(); // Kategorileri topla ve tekrarları kaldır
    cats.sort(); // Alfabetik sırala
    return ['Tümü', ...cats]; // 'Tümü' seçeneğini başa ekle
  }

  List<MenuItem> get filteredItems { // Seçili kategori ve aramaya göre filtrelenmiş liste
    return menuItems.where((item) {
      final matchesCategory = selectedCategory == 'Tümü' || item.category == selectedCategory; // Kategori kontrolü
      final matchesQuery = query.isEmpty || item.name.toLowerCase().contains(query.toLowerCase()); // Arama kontrolü
      return matchesCategory && matchesQuery; // Her iki koşul sağlanmalıdır
    }).toList();
  }

  @override
  Widget build(BuildContext context) { // UI oluşturma
    final items = filteredItems; // Filtrelenmiş listeyi tek seferde hesapla
    final currentHash = Object.hash(selectedCategory, query, items.length); // Filtre değişimini tespit et
    if (currentHash != _filterHash) {
      _filterHash = currentHash; // Önceki hash'i güncelle
      WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleVisibility(items.length)); // Görünürlük animasyonlarını planla
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Menü', style: GoogleFonts.poppins()), // Başlık Poppins ile
        centerTitle: true, // Başlığı ortala
        bottom: PreferredSize( // AppBar altına arama ve menü yerleştir
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // İç boşluk
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white24, // Arama kutusu arkaplanı
                      borderRadius: BorderRadius.circular(12), // Yuvarlatılmış köşe
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white70), // Arama ikonu
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white), // Metin rengi
                            decoration: const InputDecoration(border: InputBorder.none, hintText: 'Ara', hintStyle: TextStyle(color: Colors.white54)), // Placeholder
                            onChanged: (v) => setState(() => query = v), // Arama sorgusunu güncelle
                          ),
                        ),
                        if (query.isNotEmpty) // Arama varsa temizleme ikonu göster
                          GestureDetector(
                            onTap: () => setState(() => query = ''), // Tıklayınca temizle
                            child: const Icon(Icons.close, color: Colors.white70),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>( // Sağ üst menü (favoriler, hakkında)
                  icon: const Icon(Icons.menu),
                  onSelected: (v) {
                    if (v == 'favorites') Navigator.of(context).pushNamed('/favorites'); // Favoriler ekranı
                    if (v == 'about') {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Smart Menu',
                        applicationLegalese: '© Yusi',
                      ); // Hakkında
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'favorites', child: Text('Favoriler')),
                    PopupMenuItem(value: 'about', child: Text('Hakkında')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Column( // Ana içerik: kategori çubukları + liste
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final cat in categories)
                    ChoiceChip(
                      label: Text(cat, style: GoogleFonts.poppins(color: cat == selectedCategory ? Colors.white : Colors.black)), // Etiket
                      selected: cat == selectedCategory,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.grey[200],
                      onSelected: (_) => setState(() => selectedCategory = cat),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher( // Filtre değişikliklerinde geçiş animasyonu
              duration: const Duration(milliseconds: 300),
              child: items.isEmpty
                  ? Center(key: const ValueKey('empty'), child: Text('Aradığınız ürün bulunamadı', style: GoogleFonts.poppins())) // Boş durum
                  : ListView.builder( // Ürün listesini oluştur
                      key: ValueKey(selectedCategory + query), // List key'i filtreye bağlı
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      cacheExtent: 800, // Daha akıcı kaydırma için önbellek
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index]; // Menü öğesi
                        final visible = _visibleItems.contains(index); // Görünürlük durumu (stagger)
                        return Selector<FavoritesModel, bool>( // Her kart sadece favori durumu değiştiğinde yeniden çizilsin
                          selector: (_, model) => model.isFavorite(item.id),
                          builder: (context, isFav, _) {
                            return MenuListTile(
                              item: item,
                              isFavorite: isFav,
                              visible: visible,
                              onTap: () => _openDetail(item), // Detay sayfasına geçişi özel animasyonla yap
                              onToggleFavorite: () {
                                final favModel = context.read<FavoritesModel>(); // Modeli oku
                                favModel.toggle(item.id); // Favori durumunu tersine çevir
                                final added = !isFav; // Mevcut durum tersine dönecek
                                final message = added ? '${item.name} favorilere eklendi' : '${item.name} favorilerden kaldırıldı';
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))); // Kullanıcıya bilgi ver
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _scheduleVisibility(int length) { // Stagger animasyonunu tetikle
    _visibleItems.clear(); // Önceki görünürlük durumunu sıfırla
    for (var i = 0; i < length; i++) {
      Future.delayed(Duration(milliseconds: 70 * i), () {
        if (!mounted) return; // Widget dispose olduysa işlem yapma
        setState(() => _visibleItems.add(i)); // İlgili kartı görünür yap
      });
    }
  }

  void _openDetail(MenuItem item) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 520),
      reverseTransitionDuration: const Duration(milliseconds: 360),
      pageBuilder: (context, animation, secondaryAnimation) => MenuDetail(item: item),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final eased = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
        final fade = Tween<double>(begin: 0, end: 1).animate(eased);
        final slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(eased);
        final scale = Tween<double>(begin: 0.96, end: 1).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack, reverseCurve: Curves.easeInBack));

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(scale: scale, child: child),
          ),
        );
      },
    ));
  }
}

class MenuListTile extends StatefulWidget { // Menü kartını temsil eden widget
  final MenuItem item; // Kartın gösterdiği öğe
  final bool isFavorite; // Favori durumu
  final bool visible; // Stagger ile görünürlük
  final VoidCallback onTap; // Kart tıklandığında çalışacak aksiyon
  final VoidCallback onToggleFavorite; // Favori butonuna basıldığında çağrılacak fonksiyon

  const MenuListTile({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.visible,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  State<MenuListTile> createState() => _MenuListTileState();
}

class _MenuListTileState extends State<MenuListTile> { // Kartın kendi hover state'i
  bool _isHovering = false; // Masaüstünde fare ile üzerine gelinip gelinmediği

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema referansı
    final textTheme = theme.textTheme; // Metin stilleri
    final hoverShadow = _isHovering ? const Offset(0, 10) : const Offset(0, 4); // Hover'a göre gölge offset'i
    final hoverBlur = _isHovering ? 20.0 : 10.0; // Hover'a göre blur miktarı
    final surfaceColor = Colors.white.withAlpha((0.05 * 255).round()); // Kartın ana rengi
    final scale = widget.visible ? (_isHovering ? 1.015 : 1.0) : 0.96; // Görünürlüğe ve hover'a göre ölçek

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      opacity: widget.visible ? 1 : 0, // Görünürse opak
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        offset: widget.visible ? Offset.zero : const Offset(0, 0.05), // Kaydırma animasyonu
        child: AnimatedScale(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutBack,
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: surfaceColor, // Saydam yüzey
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha((0.04 * 255).round())),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha((0.20 * 255).round()), blurRadius: hoverBlur, offset: hoverShadow), // Gölge
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: theme.colorScheme.primary.withAlpha((0.18 * 255).round()),
                hoverColor: Colors.white.withAlpha((0.02 * 255).round()),
                onHover: (value) => setState(() => _isHovering = value), // Hover durumunu güncelle
                onTap: widget.onTap, // Kart tıklandığında detay ekranına git
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      _MenuThumbnail(imagePath: widget.item.image, heroTag: widget.item.id), // Sol taraftaki küçük görsel
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.item.name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600) ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), // Ürün adı
                            const SizedBox(height: 4),
                            Text(widget.item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: textTheme.bodySmall), // Kısa açıklama
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.item.price.toStringAsFixed(0)} ₺',
                            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold) ?? const TextStyle(fontWeight: FontWeight.bold),
                          ), // Fiyat
                          IconButton(
                            onPressed: widget.onToggleFavorite, // Favori durumunu değiştir
                            icon: AnimatedScale(
                              scale: widget.isFavorite ? 1.15 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: widget.isFavorite ? Colors.redAccent : Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuThumbnail extends StatelessWidget { // Hero animasyonlu küçük görsel
  final String imagePath; // Görsel yolu
  final String heroTag; // Hero tag'i (MenuItem id'si string)

  const _MenuThumbnail({required this.imagePath, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Hero(
        tag: heroTag, // Hero animasyonu için benzersiz tag
        child: Image.asset(
          imagePath,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) => Container(
            width: 64,
            height: 64,
            color: Colors.grey[200],
            child: const Icon(Icons.fastfood, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
