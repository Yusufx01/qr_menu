import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/menu_items.dart';

class FavoritesModel extends ChangeNotifier {
  static const _kPrefsKey = 'favorites';
  final Set<String> _favIds = {};

  FavoritesModel();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kPrefsKey) ?? [];
    _favIds.clear();
    _favIds.addAll(list);
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kPrefsKey, _favIds.toList());
  }

  bool isFavorite(String id) => _favIds.contains(id);

  void toggle(String id) {
    if (_favIds.contains(id)) {
      _favIds.remove(id);
    } else {
      _favIds.add(id);
    }
    notifyListeners();
    _save();
  }

  List<String> get favoriteIds => _favIds.toList();

  List<MenuItem> get favoriteItems =>
      menuItems.where((m) => _favIds.contains(m.id)).toList();
}
