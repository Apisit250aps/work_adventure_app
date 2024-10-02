import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final Function() onClick;
  final bool isLoading;
  final String buttonText; // Added for customization
  final Color backgroundColor; // Added for customization

  const SquareButton({
    super.key,
    required this.onClick,
    required this.isLoading,
    this.buttonText = "Get Started", // Default button text
    this.backgroundColor = Colors.black, // Default background color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                buttonText, // Use customizable button text
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
