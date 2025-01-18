import 'package:flutter/material.dart';
import 'package:food_finder/components/styles.dart';

class BoxedTextField extends StatelessWidget {
  String label;
  IconData icon;
  TextEditingController? controller;
  bool obscured;

  BoxedTextField({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.obscured = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscured,
      decoration: boxedInputDecoration(label = label, icon = icon),
    );
  }
}

class BlueButton extends StatelessWidget {
  VoidCallback onPressed;
  String text;

  BlueButton({super.key, required this.text, required this.onPressed});

  double width = double.infinity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text, style: whiteBoldText),
      ),
    );
  }
}
