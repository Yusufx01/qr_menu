import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/menu_items.dart';
import 'menu_detail.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'Tümü';
  String query = '';

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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
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
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Hero(
                                tag: item.id,
                                child: Image.asset(
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
                                  IconButton(
                                    onPressed: () {
                                      // simple favorite placeholder
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} favorilere eklendi')));
                                    },
                                    icon: const Icon(Icons.favorite_border),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => MenuDetail(item: item)),
                              );
                            },
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
