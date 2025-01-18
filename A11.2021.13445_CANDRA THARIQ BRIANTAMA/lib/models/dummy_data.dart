// lib/models/dummy_data.dart
import 'menu.dart';
import 'restaurant.dart';

List<Restaurant> dummyRestaurants = [
  Restaurant(
    name: 'Restoran A',
    description: 'Restoran A menyediakan makanan internasional.',
    address: 'Jl. A No. 1',
    phone: '081234567890',
    website: 'https://restorana.com',
    latitude: -6.2088,
    longitude: 106.8456,
    image: 'assets/images/resto_default.png',
    
    // image: 'https://via.placeholder.com/150',
  ),
  Restaurant(
    name: 'Restoran B',
    description: 'Restoran B menyediakan makanan lokal.',
    address: 'Jl. B No. 2',
    phone: '081234567891',
    website: 'https://restoranb.com',
    latitude: -6.2089,
    longitude: 106.8457,
    image: null,
  ),
  Restaurant(
    name: 'Restoran C',
    description: 'Restoran C menyediakan makanan khas.',
    address: 'Jl. C No. 3',
    phone: '081234567892',
    website: 'https://restoranc.com',
    latitude: -6.2090,
    longitude: 106.8458,
    image: null,
  ),
  Restaurant(
    name: 'Restoran D',
    description: 'Restoran D menyediakan makanan cepat saji.',
    address: 'Jl. D No. 4',
    phone: '081234567893',
    website: 'https://restorand.com',
    latitude: -6.2091,
    longitude: 106.8459,
    image: null,
  ),
  Restaurant(
    name: 'Restoran E',
    description: 'Restoran E menyediakan makanan khas Indonesia.',
    address: 'Jl. E No. 5',
    phone: '081234567894',
    website: 'https://restorane.com',
    latitude: -6.2092,
    longitude: 106.8460,
    image: null,
  ),
];

List<Menu> dummyMenus = [
  Menu(
    name: 'Menu 1',
    restoId: 1,
    description: 'Deskripsi Menu 1',
    price: 25000,
    image: null,
  ),
  Menu(
    name: 'Menu 2',
    restoId: 1,
    description: 'Deskripsi Menu 2',
    price: 30000,
    image: null,
  ),
  // Tambahkan menu lainnya di sini
];
