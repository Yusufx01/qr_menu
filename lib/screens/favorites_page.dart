import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/favorites_model.dart';
import 'menu_detail.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favModel = context.watch<FavoritesModel>();
    final items = favModel.favoriteItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriler'),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? Center(child: Text('Henüz favori yok', style: GoogleFonts.poppins()))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Hero(
                        tag: item.id,
                        child: Image.asset(item.image, width: 56, height: 56, fit: BoxFit.cover),
                      ),
                    ),
                    title: Text(item.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => favModel.toggle(item.id),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MenuDetail(item: item))),
                  ),
                );
              },
            ),
    );
  }
}
