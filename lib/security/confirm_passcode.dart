import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'keypad.dart';
import 'enter_passcode.dart';

class ConfirmPasscode extends StatefulWidget {
  final String initialPasscode;

  ConfirmPasscode({required this.initialPasscode});

  @override
  _ConfirmPasscodeState createState() => _ConfirmPasscodeState();
}

class _ConfirmPasscodeState extends State<ConfirmPasscode> {
  String enteredPasscode = '';
  int currentIndex = -1;

  void addToPasscode(String digit) {
    if (enteredPasscode.length < 4) {
      setState(() {
        enteredPasscode += digit;
        currentIndex = enteredPasscode.length - 1;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          currentIndex = -1;
        });
      });

      if (enteredPasscode.length == 4) {
        _verifyPasscode(enteredPasscode);
      }
    }
  }

  void _verifyPasscode(String enteredPasscode) async {
    if (enteredPasscode == widget.initialPasscode) {
      // Save passcode in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_pin', enteredPasscode);

      // Navigate to EntryPage to enter the PIN again
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EntryPage()),
      );
    } else {
      // Passcodes do not match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passcodes do not match. Please try again.')),
      );
      setState(() {
        enteredPasscode = ''; // Clear the entered passcode
      });
    }
  }

  void deleteDigit() {
    setState(() {
      if (enteredPasscode.isNotEmpty) {
        enteredPasscode =
            enteredPasscode.substring(0, enteredPasscode.length - 1);
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
                    Text(
                      'Confirm PIN',
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Please re-enter your PIN to confirm',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: Color.fromARGB(255, 152, 152, 152),
                        fontWeight: FontWeight.w400,
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
                              index < enteredPasscode.length
                                  ? (index == currentIndex
                                      ? enteredPasscode[index]
                                      : '*')
                                  : '',
                              style: const TextStyle(fontSize: 24),
                            ),
                          );
                        }),
                      ),
                    ),
                    // Custom keypad
                    Keypad(
                      onDigitPressed: addToPasscode,
                      onDeletePressed: deleteDigit,
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
