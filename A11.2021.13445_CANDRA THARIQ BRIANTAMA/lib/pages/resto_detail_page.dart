// lib/pages/restaurant_detail_page.dart
import 'package:flutter/material.dart';

import 'package:food_finder/components/styles.dart';
import 'package:food_finder/components/widgets.dart';
import 'package:food_finder/helpers/api_services.dart';
import 'package:food_finder/helpers/variables.dart';
import 'package:food_finder/models/review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/menu_list_tab.dart';
import '../models/menu.dart';
import '../models/restaurant.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;
  final Review? ulasan;
  List<Review> review = [];
  List<Menu> menus = [];

  RestaurantDetailPage(
      {super.key, required this.restaurant, required this.menus, this.ulasan});

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final reviews = await APIServices().getReview(widget.restaurant.id);
      setState(() {
        widget.review = reviews;
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<void> _deleteReview(int reviewId) async {
    try {
      await APIServices().deleteReview(reviewId);

      setState(() {
        widget.review.removeWhere((review) => review.id == reviewId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ulasan berhasil dihapus.')),
      );
    } catch (e) {
      print('Error deleting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus ulasan.')),
      );
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void _openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapUrl = Uri.parse(
      'geo:$latitude,$longitude?q=$latitude,$longitude',
    );

    final Uri googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    _launchInBrowser(googleMapUrl);
  }

  void _addReview() {
    final TextEditingController commentController = TextEditingController();
    final TextEditingController ratingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Komentar",
                prefixIcon: const Icon(Icons.comment),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue[900]!),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ratingController,
              decoration: InputDecoration(
                labelText: "Rating",
                prefixIcon: const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue[900]!),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.grey,
                elevation: 1.5,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.grey,
                elevation: 1.5,
              ),
              onPressed: () async {
                final String comment = commentController.text;
                final int? rating = int.tryParse(ratingController.text);

                if (comment.isNotEmpty &&
                    rating != null &&
                    rating > 0 &&
                    rating <= 5) {
                  try {
                    // Fetch user profile to get user_id
                    final profile = await APIServices().getProfile();
                    final int userId = profile['id'];

                    final Map<String, dynamic> reviewData = {
                      "restaurant_id": widget.restaurant.id,
                      "user_id": userId,
                      "rating": rating,
                      "comment": comment,
                    };

                    await APIServices().addReview(reviewData);
                    await _fetchReviews(); // Refresh reviews after adding
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Review berhasil ditambahkan.')),
                    );
                  } catch (e) {
                    // Handle error
                    print('Error adding review: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Gagal menambahkan review.')),
                    );
                  }
                } else {
                  // Show validation error
                  print('Invalid input');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Input tidak valid.')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }

  void _editReview(Review review) {
    final TextEditingController commentController =
        TextEditingController(text: review.comment);
    final TextEditingController ratingController =
        TextEditingController(text: review.rating.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Komentar",
                prefixIcon: const Icon(Icons.comment),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue[900]!),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ratingController,
              decoration: InputDecoration(
                labelText: "Rating",
                prefixIcon: const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue[900]!),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.grey,
                elevation: 1.5,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.grey,
                elevation: 1.5,
              ),
              onPressed: () async {
                final String updatedComment = commentController.text;
                final int? updatedRating = int.tryParse(ratingController.text);

                if (updatedComment.isNotEmpty &&
                    updatedRating != null &&
                    updatedRating > 0 &&
                    updatedRating <= 5) {
                  try {
                    final profile = await APIServices().getProfile();
                    final int userId = profile['id'];

                    final Map<String, dynamic> updatedReviewData = {
                      "restaurant_id": widget.restaurant.id,
                      "user_id": userId,
                      "rating": updatedRating,
                      "comment": updatedComment,
                    };

                    await APIServices()
                        .editReview(review.id, updatedReviewData);
                    await _fetchReviews(); // Refresh reviews after editing
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Review berhasil diedit.')),
                    );
                  } catch (e) {
                    print('Error editing review: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal mengedit review.')),
                    );
                  }
                } else {
                  print('Invalid input');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Input tidak valid.')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.grey,
                elevation: 1.5,
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _deleteReview(review.id);
              },
              child: const Text(
                'Hapus',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.restaurant.name,
            style: whiteBoldText,
          ),
          backgroundColor: Colors.blue[900],
          bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: [
                Tab(text: 'Menu'),
                Tab(text: 'Info'),
                Tab(
                  text: 'Review',
                )
              ]),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.restaurant.image == null
                      ? const AssetImage('assets/images/resto_default.png')
                      : NetworkImage(Variables.url + widget.restaurant.image!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.blue[900]!.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.restaurant.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MenuListTab(
                    resto: widget.restaurant,
                    onMenuAdded: (menu) {
                      // Aksi ketika menu baru ditambahkan
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.restaurant.description ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Address:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          Text(
                            widget.restaurant.address ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Website:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (widget.restaurant.website != null &&
                                  widget.restaurant.website!.isNotEmpty) {
                                String url = widget.restaurant.website!;
                                if (!url.startsWith('http')) {
                                  url = 'https://$url';
                                }
                                final uri = Uri.parse(url);
                                _launchInBrowser(uri);
                              }
                            },
                            child: Text(
                              widget.restaurant.website ?? 'http://',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[900],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Phone:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _makePhoneCall(widget.restaurant.phone ?? ''),
                            child: Text(
                              widget.restaurant.phone ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[900],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 100)
                        ],
                      ),
                    ),
                  ),

                  // Tab Ulasan
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "List Review",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900]),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: widget.review.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: widget.review.map((review) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            _editReview(review);
                                          },
                                          // onLongPress: () {
                                          //   showModalBottomSheet(
                                          //     context: context,
                                          //     builder: (BuildContext context) {
                                          //       return Column(
                                          //         mainAxisSize:
                                          //             MainAxisSize.min,
                                          //         children: [
                                          //           ListTile(
                                          //             leading: Icon(Icons.edit,
                                          //                 color:
                                          //                     Colors.blue[900]),
                                          //             title: const Text(
                                          //                 'Edit Review'),
                                          //             onTap: () {
                                          //               Navigator.pop(context);
                                          //               _editReview(review);
                                          //             },
                                          //           ),
                                          //           ListTile(
                                          //             leading: const Icon(
                                          //                 Icons.delete,
                                          //                 color: Colors.red),
                                          //             title: const Text(
                                          //                 'Hapus Review'),
                                          //             onTap: () async {
                                          //               Navigator.pop(context);
                                          //               await _deleteReview(
                                          //                   review.id);
                                          //             },
                                          //           ),
                                          //         ],
                                          //       );
                                          //     },
                                          //   );
                                          // },
                                          child: SizedBox(
                                            width: double
                                                .infinity, // Mengatur lebar penuh
                                            child: Card(
                                              elevation: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 8),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: Colors
                                                                .blue[900],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    review.user
                                                                            .username ??
                                                                        'Anonymous',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                              .blue[
                                                                          900],
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        '${review.rating}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.blue[900],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              4),
                                                                      const Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .amber,
                                                                        size:
                                                                            16,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 2),
                                                              Text(
                                                                review.comment ??
                                                                    '',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                          .blue[
                                                                      900],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )
                                : Center(
                                    child: Text(
                                      'Belum ada review.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        BlueButton(
                          text: "Tambah Review",
                          onPressed: () {
                            _addReview();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () => _openGoogleMaps(
                  widget.restaurant.latitude ?? 0,
                  widget.restaurant.longitude ?? 0,
                ),
                backgroundColor: Colors.blue[900],
                child: const Icon(Icons.map, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
