// lib/pages/profile_restaurant_page.dart
import 'package:flutter/material.dart';
import 'package:food_finder/components/styles.dart';
import 'package:food_finder/models/dummy_data.dart';
import 'package:food_finder/models/restaurant.dart';

import '../components/menu_list_tab.dart';
import '../components/restaurant_form_tab.dart';
import '../components/widgets.dart';
import '../models/menu.dart';
import 'menu_form_page.dart';

class ProfileRestaurantPage extends StatefulWidget {
  Restaurant? resto;
  ProfileRestaurantPage({super.key, this.resto});

  @override
  _ProfileRestaurantPageState createState() => _ProfileRestaurantPageState();
}

class _ProfileRestaurantPageState extends State<ProfileRestaurantPage> {
  final int _currentIndex = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _latLongController = TextEditingController();

  final List<Menu> _menus = dummyMenus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final curResto = widget.resto;
    if (curResto != null) {
      _nameController.text = curResto.name;
      _descriptionController.text = curResto.description ?? '';
      _addressController.text = curResto.address ?? '';
      _phoneController.text = curResto.phone ?? '';
      _websiteController.text = curResto.website ?? '';
      _latLongController.text =
          "${(curResto.latitude ?? 0)},${(curResto.longitude ?? 0)}";
    }
  }

  void _addMenu(Menu menu) {
    setState(() {
      _menus.add(menu);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil Restoran', style: whiteBoldText),
          backgroundColor: Colors.blue[900],
          bottom: const TabBar(
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white54,
            ),
            tabs: [Tab(text: 'Profil'), Tab(text: 'Daftar Menu')],
          ),
        ),
        body: TabBarView(
          children: [
            RestaurantFormTab(
              nameController: _nameController,
              descriptionController: _descriptionController,
              addressController: _addressController,
              phoneController: _phoneController,
              websiteController: _websiteController,
              latLongController: _latLongController,
              resto: widget.resto,
            ),
            MenuListTab(
              resto: widget.resto,
              onMenuAdded: _addMenu,
              canAddMenu: true,
            ),
          ],
        ),
        floatingActionButton: _currentIndex == 1
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuFormPage(
                        onMenuAdded: _addMenu,
                        resto: widget.resto!,
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.blue[900],
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

class NoRestoPage extends StatefulWidget {
  const NoRestoPage({super.key});

  @override
  State<NoRestoPage> createState() => _NoRestoTabState();
}

class _NoRestoTabState extends State<NoRestoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          child: Column(
            children: [
              const Text(
                'Anda belum memiliki restoran',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              BlueButton(
                text: "Buat Resto Sekarang",
                onPressed: () {
                  Navigator.pushNamed(context, '/profile_restaurant');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
