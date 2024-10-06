import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Keypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final Function onDeletePressed;

  Keypad({required this.onDigitPressed, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 20),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 20),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 20),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Row _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map((digit) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: KeypadButton(digit: digit, onPressed: onDigitPressed),
        );
      }).toList(),
    );
  }

  Row _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 70), // Placeholder for alignment
        const SizedBox(width: 20),
        KeypadButton(digit: '0', onPressed: onDigitPressed),
        const SizedBox(width: 20),
        Container(
          height: 80,
          width: 80,
          child: ElevatedButton(
            onPressed: () => onDeletePressed(),
            child: const Text('Del', style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class KeypadButton extends StatelessWidget {
  final String digit;
  final Function(String) onPressed;

  KeypadButton({required this.digit, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: const Color.fromARGB(255, 239, 239, 239),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: () => onPressed(digit),
        child: Text(
          digit,
          style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }
}
