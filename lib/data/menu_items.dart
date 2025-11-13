class MenuItem {
  final String name;
  final String image;
  final double price;
  final String category;

  MenuItem({
    required this.name,
    required this.image,
    required this.price,
    required this.category,
  });
}

final List<MenuItem> menuItems = [
  MenuItem(
    name: 'Türk Kahvesi',
    image: 'images/kahve.jpg',
    price: 35,
    category: 'İçecekler',
  ),
  MenuItem(
    name: 'Çay',
    image: 'images/cay.jpg',
    price: 20,
    category: 'İçecekler',
  ),
  MenuItem(
    name: 'Trileçe',
    image: 'images/tatli.jpg',
    price: 50,
    category: 'Tatlılar',
  ),
];
