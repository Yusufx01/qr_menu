class MenuItem {
  final String id;
  final String name;
  final String image;
  final double price;
  final String category;
  final String description;

  MenuItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    this.description = '',
  });
}

final List<MenuItem> menuItems = [
  MenuItem(
    id: 'm1',
    name: 'Türk Kahvesi',
    image: 'assets/images/kahve.jpg',
    price: 35,
    category: 'İçecekler',
    description: 'Geleneksel Türk kahvesi, köpüklü ve taze çekilmiş.'
  ),
  MenuItem(
    id: 'm2',
    name: 'Çay',
    image: 'assets/images/cay.jpg',
    price: 20,
    category: 'İçecekler',
    description: 'Demli ve sıcak çay.'
  ),
  MenuItem(
    id: 'm3',
    name: 'Trileçe',
    image: 'assets/images/tatli.jpg',
    price: 50,
    category: 'Tatlılar',
    description: 'Balkabaklı veya klasik trileçe seçenekleri.'
  ),
  MenuItem(
    id: 'm4',
    name: 'Simit',
    image: 'assets/images/tatli.jpg',
    price: 12,
    category: 'Atıştırmalıklar',
    description: 'Taze susamlı simit.'
  ),
  MenuItem(
    id: 'm5',
    name: 'Menemen',
    image: 'assets/images/tatli.jpg',
    price: 45,
    category: 'Kahvaltılar',
    description: 'Domatesli peynirli menemen.'
  ),
  MenuItem(
    id: 'm6',
    name: 'Tavuk Şinitzel',
    image: 'assets/images/tatli.jpg',
    price: 120,
    category: 'Yemekler',
    description: 'Yanında patates kızartması ile.'
  ),
  MenuItem(
    id: 'm7',
    name: 'Künefe',
    image: 'assets/images/tatli.jpg',
    price: 75,
    category: 'Tatlılar',
    description: 'Sıcak ve şerbetli künefe.'
  ),
  MenuItem(
    id: 'm8',
    name: 'Cheeseburger',
    image: 'assets/images/tatli.jpg',
    price: 95,
    category: 'Yemekler',
    description: 'Ev yapımı burger, cheddar peyniri ile.'
  ),
  MenuItem(
    id: 'm9',
    name: 'Patates kızartması',
    image: 'assets/images/tatli.jpg',
    price: 30,
    category: 'Atıştırmalıklar',
    description: 'Sıcak ve çıtır.'
  ),
];
