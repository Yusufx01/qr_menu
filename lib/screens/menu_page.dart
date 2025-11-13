import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/menu_items.dart';
import '../models/favorites_model.dart';
import 'menu_detail.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'Tümü';
  String query = '';
  final Set<int> _visibleItems = {};
  int _filterHash = 0;

  List<String> get categories {
    final cats = menuItems.map((e) => e.category).toSet().toList();
    cats.sort();
    return ['Tümü', ...cats];
  }

  List<MenuItem> get filteredItems {
    return menuItems.where((item) {
      final matchesCategory = selectedCategory == 'Tümü' || item.category == selectedCategory;
      final matchesQuery = query.isEmpty || item.name.toLowerCase().contains(query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentHash = selectedCategory.hashCode ^ query.hashCode ^ filteredItems.length;
    if (currentHash != _filterHash) {
      _filterHash = currentHash;
      _visibleItems.clear();
      for (var i = 0; i < filteredItems.length; i++) {
        Future.delayed(Duration(milliseconds: 80 * i), () {
          if (!mounted) return;
          setState(() => _visibleItems.add(i));
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Menü', style: GoogleFonts.poppins()),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white70),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(border: InputBorder.none, hintText: 'Ara', hintStyle: TextStyle(color: Colors.white54)),
                            onChanged: (v) => setState(() => query = v),
                          ),
                        ),
                        if (query.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() => query = ''),
                            child: const Icon(Icons.close, color: Colors.white70),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu),
                  onSelected: (v) {
                    if (v == 'favorites') Navigator.of(context).pushNamed('/favorites');
                    if (v == 'about') showAboutDialog(context: context, applicationName: 'Smart Menu', applicationLegalese: '© Yusufx01');
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'favorites', child: Text('Favoriler')),
                    const PopupMenuItem(value: 'about', child: Text('Hakkında')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final selected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat, style: GoogleFonts.poppins(color: selected ? Colors.white : Colors.black)),
                    selected: selected,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.grey[200],
                    onSelected: (_) => setState(() => selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: filteredItems.isEmpty
                  ? Center(key: const ValueKey('empty'), child: Text('Aradığınız ürün bulunamadı', style: GoogleFonts.poppins()))
                  : ListView.builder(
                      key: ValueKey(selectedCategory + query),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final visible = _visibleItems.contains(index);
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 450),
                          opacity: visible ? 1 : 0,
                          child: Transform.translate(
                            offset: Offset(0, visible ? 0 : 14),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                                      child: Hero(
                                        tag: item.id,
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              item.image,
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, _, __) => Container(
                                                width: 56,
                                                height: 56,
                                                color: Colors.grey[200],
                                                child: const Icon(Icons.fastfood, color: Colors.grey),
                                              ),
                                            ),
                                            Positioned(
                                              right: -6,
                                              top: -6,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Colors.amberAccent.shade700]),
                                                  borderRadius: BorderRadius.circular(8),
                                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 6)],
                                                ),
                                                child: const Text('PREMIUM', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                            ),
                            title: Text(item.name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                            subtitle: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                                    trailing: SizedBox(
                              width: 120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${item.price.toStringAsFixed(0)} ₺', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Builder(builder: (ctx) {
                                    final favModel = context.read<FavoritesModel>();
                                    final isFav = context.select<FavoritesModel, bool>((m) => m.isFavorite(item.id));
                                    return GestureDetector(
                                      onTap: () {
                                        favModel.toggle(item.id);
                                        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(isFav ? '${item.name} favorilerden kaldırıldı' : '${item.name} favorilere eklendi')));
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 220),
                                        transform: Matrix4.identity()..scale(isFav ? 1.14 : 1.0),
                                        child: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.redAccent : Colors.white70),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => MenuDetail(item: item)),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
