// lib/models/restaurant.dart
class Restaurant {
  late int id;
  final String name;
  final String? description;
  final String? address;
  final String? phone;
  final String? website;
  final double? latitude;
  final double? longitude;
  final String? image;


  Restaurant(
      {this.id = 0,
      required this.name,
      this.description,
      this.address,
      this.phone,
      this.website,
      this.latitude,
      this.longitude,
      this.image,
     });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      website: json['website'],
      latitude: json['lattitude'],
      longitude: json['longitude'],
      image: json['image'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'phone': phone,
      'website': website,
      'lattitude': latitude,
      'longitude': longitude,
    };
  }
}
