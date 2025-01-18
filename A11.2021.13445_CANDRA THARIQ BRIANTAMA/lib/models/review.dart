class Review {
  final int id;
  User user;
  final int rating;
  final String comment;

  Review(
      {required this.id,
      required this.rating,
      required this.comment,
      required this.user});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      user: User.fromJson(json['user']),
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'rating': rating,
      'comment': comment,
    };
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
