import 'package:flutter/material.dart'; // Material bileşenleri
import 'package:google_fonts/google_fonts.dart'; // Poppins fontu
import 'package:provider/provider.dart'; // Provider ile state okuma
import '../models/favorites_model.dart'; // Favoriler modeline erişim
import 'menu_detail.dart'; // Detay sayfasına geçiş için

class FavoritesPage extends StatelessWidget { // Kullanıcının favori ürünlerini listeleyen ekran
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favModel = context.watch<FavoritesModel>(); // Favoriler modelini dinle (yeniden build için)
    final items = favModel.favoriteItems; // Favori öğeleri al

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriler'), // Başlık
        centerTitle: true,
      ),
      body: items.isEmpty
          ? Center(child: Text('Henüz favori yok', style: GoogleFonts.poppins())) // Boş durum mesajı
          : ListView.builder( // Favori öğeleri listele
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index]; // Her favori öğe
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Hafif yuvarlatma
                  elevation: 2,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Hero(
                        tag: item.id, // Hero ile detay geçişi
                        child: Image.asset(item.image, width: 56, height: 56, fit: BoxFit.cover), // Ürün resmi
                      ),
                    ),
                    title: Text(item.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)), // Ürün adı
                    subtitle: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis), // Kısa açıklama
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline), // Sil butonu (favoriden kaldır)
                      onPressed: () => favModel.toggle(item.id), // Favoriyi toggle et
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MenuDetail(item: item))), // Detay sayfasına git
                  ),
                );
              },
            ),
    );
  }
}
