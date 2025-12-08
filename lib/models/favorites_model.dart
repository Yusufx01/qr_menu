import 'package:flutter/foundation.dart'; // ChangeNotifier gibi temel tipler
import 'package:shared_preferences/shared_preferences.dart'; // Kalıcı favori saklama için
import '../data/menu_items.dart'; // Menü verilerine erişmek için

class FavoritesModel extends ChangeNotifier { // Favoriler için ChangeNotifier tabanlı model
  static const _kPrefsKey = 'favorites'; // SharedPreferences anahtar adı
  final Set<String> _favIds = {}; // Favori ID'lerini tutan set

  FavoritesModel(); // Varsayılan constructor

  Future<void> load() async { // SharedPreferences'dan favorileri yükle
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kPrefsKey) ?? []; // Kayıtlı liste yoksa boş liste al
    _favIds.clear();
    _favIds.addAll(list); // Set'e ekle
    notifyListeners(); // Dinleyicilere güncelleme bildir
  }

  Future<void> _save() async { // Favorileri kalıcıya kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kPrefsKey, _favIds.toList());
  }

  bool isFavorite(String id) => _favIds.contains(id); // Bir id favori mi?

  void toggle(String id) { // Favori ekle/kaldır
    if (_favIds.contains(id)) {
      _favIds.remove(id);
    } else {
      _favIds.add(id);
    }
    notifyListeners(); // UI'ı bilgilendir
    _save(); // Değişikliği kaydet
  }

  List<String> get favoriteIds => _favIds.toList(); // Favori id'lerinin listesi

  List<MenuItem> get favoriteItems => // Favori ID'lerine göre MenuItem nesnelerini getir
      menuItems.where((m) => _favIds.contains(m.id)).toList();
}
