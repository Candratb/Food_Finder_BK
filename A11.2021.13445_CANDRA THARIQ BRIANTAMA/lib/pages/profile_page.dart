// lib/widgets/profile_page.dart
import 'package:flutter/material.dart';
import 'package:food_finder/components/styles.dart';
import 'package:food_finder/components/widgets.dart';
import 'package:food_finder/helpers/api_services.dart';
import 'package:food_finder/models/restaurant.dart';
import 'package:food_finder/pages/profile_resto_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final api = APIServices();
  Restaurant? resto;

  void getProfile() async {
    final profile = await api.getProfile();
    // print(profile);
    setState(() {
      _usernameController.text = profile['username'];
      _emailController.text = profile['email'];
      _firstNameController.text = profile['first_name'];
      _lastNameController.text = profile['last_name'];
    });
    if (profile['restaurant'] != null) {
      resto = Restaurant.fromJson(profile['restaurant']);
    }
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  void updateProfile() async {
    final result = await api.updateProfile(
      _emailController.text,
      _firstNameController.text,
      _lastNameController.text,
    );
    if (result.isEmpty) {
      throw Exception("Perubahan profil gagal");
    } else {}
  }

  void changePassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (password.isNotEmpty && password == confirmPassword) {
      api
          .updatePassword(
        _oldPasswordController.text,
        password,
        confirmPassword,
      )
          .then((onValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.of(context).pop();
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ganti Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BoxedTextField(
                label: "Password Lama",
                icon: Icons.lock_outline,
                obscured: true,
                controller: _oldPasswordController,
              ),
              BoxedTextField(
                label: "Password Baru",
                icon: Icons.lock,
                obscured: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 10),
              BoxedTextField(
                label: "Konfirmasi password",
                icon: Icons.lock,
                obscured: true,
                controller: _confirmPasswordController,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ganti Password'),
              onPressed: () {
                changePassword();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToRestaurantProfile() {
    if (resto == null) {
      Navigator.pushNamed(context, '/no_resto');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ProfileRestaurantPage(
              resto: resto,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/user_default.png'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              readOnly: true,
              decoration: boxedInputDecoration("Username", Icons.person),
            ),
            const SizedBox(height: 10),
            BoxedTextField(
              label: "Email",
              icon: Icons.email,
              controller: _emailController,
            ),
            const SizedBox(height: 10),
            BoxedTextField(
              label: "Nama depan",
              icon: Icons.person_outline,
              controller: _firstNameController,
            ),
            const SizedBox(height: 10),
            BoxedTextField(
              label: "Nama belakang",
              icon: Icons.person_outline,
              controller: _lastNameController,
            ),
            const SizedBox(height: 20),
            BlueButton(
              text: "Update Profil",
              onPressed: () {
                updateProfile();
              },
            ),
            const SizedBox(height: 10),
            BlueButton(
              text: "Ganti Password",
              onPressed: _showChangePasswordDialog,
            ),
            const SizedBox(height: 10),
            BlueButton(
              text: "Resto Anda",
              onPressed: _navigateToRestaurantProfile,
            ),
          ],
        ),
      ),
    );
  }
}
