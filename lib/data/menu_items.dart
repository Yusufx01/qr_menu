class MenuItem {
  final String id; // Benzersiz id
  final String name; // Ürün adı
  final String image; // Asset yolu
  final double price; // Fiyat
  final String category; // Kategori adı
  final String description; // Açıklama
  final int calories; // Kalori bilgisi

  MenuItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    this.description = '',
    this.calories = 0,
  });
}

final List<MenuItem> menuItems = [ // Örnek menü verisi
  MenuItem(
    id: 'm1',
    name: 'Türk Kahvesi',
    image: 'assets/images/kahve.jpg',
    price: 35,
    category: 'İçecekler',
    description: 'Klasik, köpüklü Türk kahvesi — sade ya da şekerli tercih edilebilir.',
    calories: 10,
  ),
  MenuItem(
    id: 'm2',
    name: 'Çay',
    image: 'assets/images/cay.jpg',
    price: 20,
    category: 'İçecekler',
    description: 'Sıcak, demlenmiş çay. İsteğe bağlı limon ve şeker.',
    calories: 2,
  ),
  MenuItem(
    id: 'm3',
    name: 'Trileçe',
    image: 'assets/images/trilece.jpg',
    price: 50,
    category: 'Tatlılar',
    description: 'Hafif sütlü tabanlı tatlı, kremamsı dokusu ile servis edilir.',
    calories: 420,
  ),
  MenuItem(
    id: 'm4',
    name: 'Simit',
    image: 'assets/images/simit.jpg',
    price: 12,
    category: 'Atıştırmalıklar',
    description: 'Günlük taze pişmiş susamlı simit.',
    calories: 270,
  ),
  MenuItem(
    id: 'm5',
    name: 'Menemen',
    image: 'assets/images/menemen.jpg',
    price: 45,
    category: 'Kahvaltılar',
    description: 'Domates, biber ve yumurta ile yapılan ev yapımı menemen.',
    calories: 320,
  ),
  MenuItem(
    id: 'm6',
    name: 'Tavuk Şinitzel',
    image: 'assets/images/schnitzel.jpg',
    price: 120,
    category: 'Yemekler',
    description: 'İnce pane edilmiş tavuk göğsü, yanında garnitür ile.',
    calories: 650,
  ),
  MenuItem(
    id: 'm7',
    name: 'Künefe',
    image: 'assets/images/kunefe.jpg',
    price: 75,
    category: 'Tatlılar',
    description: 'Sıcak, tel kadayıf ve peynirle hazırlanmış tatlı.',
    calories: 540,
  ),
  MenuItem(
    id: 'm8',
    name: 'Cheeseburger',
    image: 'assets/images/cheeseburger.jpg',
    price: 95,
    category: 'Yemekler',
    description: 'Ev yapımı burger, cheddar peyniri, taze marul ve domates.',
    calories: 820,
  ),
  MenuItem(
    id: 'm9',
    name: 'Patates kızartması',
    image: 'assets/images/fries.jpg',
    price: 30,
    category: 'Atıştırmalıklar',
    description: 'Sıcak, çıtır patates kızartması.',
    calories: 360,
  ),
];
