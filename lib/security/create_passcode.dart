import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'keypad.dart';
import 'confirm_passcode.dart'; // Import the ConfirmPasscode page

class CreatePasscode extends StatefulWidget {
  const CreatePasscode({Key? key}) : super(key: key);

  @override
  _CreatePasscodeState createState() => _CreatePasscodeState();
}

class _CreatePasscodeState extends State<CreatePasscode> {
  String passcode = '';
  int currentIndex = -1;

  void addToPasscode(String digit) {
    if (passcode.length < 4) {
      setState(() {
        passcode += digit;
        currentIndex = passcode.length - 1;
      });

      // Hide the digit after a short delay
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          currentIndex = -1;
        });
      });

      // If 4 digits are entered, navigate to ConfirmPasscode page with a fade transition
      if (passcode.length == 4) {
        _navigateToConfirmPasscode();
      }
    }
  }

  void _navigateToConfirmPasscode() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ConfirmPasscode(initialPasscode: passcode),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final opacityAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: opacityAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void deleteDigit() {
    setState(() {
      if (passcode.isNotEmpty) {
        passcode = passcode.substring(0, passcode.length - 1);
        currentIndex = -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 236, 236, 236),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create PIN',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Setup a new PIN for your card and continue to enjoy online transactions',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color: Color.fromARGB(255, 152, 152, 152),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Display the passcode with borders
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              index < passcode.length
                                  ? (index == currentIndex
                                      ? passcode[index]
                                      : '*')
                                  : '',
                              style: const TextStyle(fontSize: 24),
                            ),
                          );
                        }),
                      ),
                    ),
                    // Custom keypad
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Keypad(
                          onDigitPressed: addToPasscode,
                          onDeletePressed: deleteDigit,
                        ),
                      ],
                    ),
                  ],
                ),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
