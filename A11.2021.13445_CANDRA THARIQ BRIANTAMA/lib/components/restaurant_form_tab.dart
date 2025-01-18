// lib/widgets/restaurant_form_tab.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_finder/components/styles.dart';
import 'package:food_finder/components/widgets.dart';
import 'package:food_finder/helpers/api_services.dart';
import 'package:food_finder/helpers/location_service.dart';
import 'package:food_finder/helpers/variables.dart';
import 'package:food_finder/models/restaurant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantFormTab extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController websiteController;
  final TextEditingController latLongController;

  Restaurant? resto;

  RestaurantFormTab({super.key, 
    required this.nameController,
    required this.descriptionController,
    required this.addressController,
    required this.phoneController,
    required this.websiteController,
    required this.latLongController,
    this.resto,
  });

  @override
  _RestaurantFormTabState createState() => _RestaurantFormTabState();
}

class _RestaurantFormTabState extends State<RestaurantFormTab> {
  XFile? _image;
  APIServices api = APIServices();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      }
    });
  }

  final LocationService _loc = LocationService();
  Position? currentPos;

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _loc.getCurrentLocation();
      setState(() {
        currentPos = position;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
    }
  }

  Future<void> saveProfile() async {
    List<String> latlong = widget.latLongController.text.split(',');
    double latitude = double.parse(latlong[0]);
    double longitude = double.parse(latlong[1]);
    Restaurant dataResto = Restaurant(
        name: widget.nameController.text,
        description: widget.descriptionController.text,
        address: widget.addressController.text,
        phone: widget.phoneController.text,
        website: widget.websiteController.text,
        latitude: latitude,
        longitude: longitude
        );

    Restaurant resResto;
    if (widget.resto == null) {
      resResto = await api.addRestaurant(dataResto);
    } else {
      dataResto.id = widget.resto!.id;
      resResto = await api.updateRestaurant(dataResto);
    }

    if (_image != null) {
      final imageFile = File(_image!.path);
      api.uploadRestoImage(resResto, imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(_image!.path),
                      width: 350,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (widget.resto != null && widget.resto!.image != null)
                        ? Image.network(
                            Variables.url + widget.resto!.image!,
                            width: 350,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/resto_default.png',
                            width: 350,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Camera', style: whiteBoldText),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Gallery', style: whiteBoldText),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BoxedTextField(
              label: "Nama menu",
              icon: Icons.restaurant,
              controller: widget.nameController,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.descriptionController,
              maxLines: 3,
              decoration: boxedInputDecoration("Deskripsi", Icons.description),
            ),
            const SizedBox(height: 10),
            BoxedTextField(
              label: "Alamat",
              icon: Icons.location_city,
              controller: widget.addressController,
            ),
            const SizedBox(height: 10),
            BoxedTextField(
              label: "No. Telepon",
              icon: Icons.phone,
              controller: widget.phoneController,
            ),
            const SizedBox(height: 10),
            BoxedTextField(
              label: "Website",
              icon: Icons.web,
              controller: widget.websiteController,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: boxedInputDecoration(
                      "Lat / Long",
                      Icons.location_pin,
                    ),
                    readOnly: true,
                    controller: widget.latLongController,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _getCurrentLocation().then((value) {
                      widget.latLongController.text =
                          "${currentPos!.latitude},${currentPos!.longitude}";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.map, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlueButton(
              text: "Simpan Profil",
              onPressed: () {
                saveProfile().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Berhasil menyimpan data resto'),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
