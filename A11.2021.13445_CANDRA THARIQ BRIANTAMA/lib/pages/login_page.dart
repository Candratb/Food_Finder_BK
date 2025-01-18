import 'package:flutter/material.dart';
import 'package:food_finder/helpers/api_driver.dart';
import 'package:food_finder/helpers/token_storage.dart';
import 'package:food_finder/pages/register_page.dart';

import '../components/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  APIDriver apiDriver = APIDriver();

  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  void checkLogin() async {
    final tokenStorage = TokenStorage();
    String? accesToken = await tokenStorage.getAccessToken();
    if (accesToken != null) {
      toDashboard();
    }
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  void _login() async {
    try {
      await apiDriver.login(usernameCtrl.text, passwordCtrl.text);
      toDashboard();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void toDashboard() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      "/main",
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Food Finder',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 20),
              BoxedTextField(
                label: "Username",
                icon: Icons.person,
                controller: usernameCtrl,
              ),
              const SizedBox(height: 10),
              BoxedTextField(
                label: "Password",
                icon: Icons.lock,
                obscured: true,
                controller: passwordCtrl,
              ),
              const SizedBox(height: 20),
              BlueButton(text: "Login", onPressed: () => _login()),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: Text(
                  'Belum punya akun? Daftar di sini',
                  style: TextStyle(color: Colors.blue[900]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
