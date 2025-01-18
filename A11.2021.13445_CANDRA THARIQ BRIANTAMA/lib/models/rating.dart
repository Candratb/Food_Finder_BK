class Rating {
  final int rating;
  User user;

  Rating({required this.rating, required this.user});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: json['rating'] ?? 0,
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String username;
  User({required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
    );
  }
}
