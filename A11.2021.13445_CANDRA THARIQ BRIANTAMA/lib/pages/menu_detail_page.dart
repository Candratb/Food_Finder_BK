import 'package:flutter/material.dart';
import 'package:food_finder/components/styles.dart';
import 'package:food_finder/components/widgets.dart';
import 'package:food_finder/helpers/api_services.dart';
import 'package:food_finder/helpers/variables.dart';
import 'package:food_finder/models/menu.dart';
import 'package:food_finder/models/rating.dart';

class MenuDetailPage extends StatefulWidget {
  final Menu menu;
  List<Rating>? rating = [];
  MenuDetailPage({super.key, required this.menu});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  APIServices api = APIServices();

  void getRating() {
    api.getRating(widget.menu.id).then((menus) {
      setState(() {
        widget.rating = menus;
      });
    });
  }

  void postRating(Map<String, dynamic> rating) {
    api.addRating(widget.menu.id, rating);
  }

  void addRating() {
    int currentRating = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Tambah Rating'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (starIndex) {
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            currentRating = starIndex + 1 == currentRating
                                ? 0
                                : starIndex + 1;
                          });
                        },
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 200),
                          tween: Tween<double>(
                            begin: 1.0,
                            end: starIndex < currentRating ? 1.2 : 1.0,
                          ),
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Icon(
                                Icons.star,
                                color: starIndex < currentRating
                                    ? Colors.orange
                                    : Colors.grey,
                                size: 50,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  final Map<String, dynamic> rating = {
                    "rating": currentRating,
                  };
                  postRating(rating);
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    getRating();
                  });
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getRating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.menu.name,
          style: whiteBoldText,
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.menu.image == null
                    ? const AssetImage('assets/images/resto_default.png')
                    : NetworkImage(Variables.url + widget.menu.image!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.menu.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Rp${widget.menu.price}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Center(
              child: Text(
                "Rating",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: widget.rating!.isNotEmpty
                  ? ListView.builder(
                      itemCount: widget.rating!.length,
                      itemBuilder: (context, index) {
                        final rating = widget.rating![index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rating.user.username,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (starIndex) {
                                  return Icon(
                                    Icons.star,
                                    color: starIndex < rating.rating
                                        ? Colors.orange
                                        : Colors.grey,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Belum ada rating.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: BlueButton(
                  text: "Tambah Rating",
                  onPressed: () {
                    addRating();
                  }))
        ],
      ),
    );
  }
}
