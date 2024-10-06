import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'keypad.dart';
import 'package:cady/screens/home.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  String enteredPasscode = '';
  int currentIndex = -1;
  String? savedPasscode; // Variable to store the saved passcode
  String?
      errorMessage; // Variable to store the error message if the PIN is incorrect

  @override
  void initState() {
    super.initState();
    _loadSavedPasscode(); // Load the saved passcode on initialization
  }

  Future<void> _loadSavedPasscode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedPasscode = prefs.getString('user_pin'); // Get the saved passcode
      print('Loaded saved passcode: $savedPasscode'); // Debugging output
    });
  }

  void addToPasscode(String digit) {
    if (enteredPasscode.length < 4) {
      setState(() {
        enteredPasscode += digit;
        currentIndex = enteredPasscode.length - 1;
      });

      // Hide the digit after a short delay
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          currentIndex = -1;
        });
      });

      // Check if 4 digits are entered
      if (enteredPasscode.length == 4) {
        _verifyPasscode();
      }
    }
  }

  void _verifyPasscode() {
    if (enteredPasscode == savedPasscode) {
      // Navigate to the HomePage if the PIN matches
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Home()), // Replace with your actual HomePage
      );
    } else {
      setState(() {
        errorMessage =
            'Incorrect PIN. Please try again.'; // Set error message if PIN is incorrect
      });

      // Clear the entered passcode after showing error
      Timer(const Duration(milliseconds: 1500), () {
        setState(() {
          enteredPasscode = ''; // Clear the entered passcode for a retry
          errorMessage = null; // Reset error message
        });
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
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter PIN',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Enter your PIN to continue',
                            style: GoogleFonts.spaceGrotesk(
                                fontSize: 14,
                                color: Color.fromARGB(255, 152, 152, 152),
                                fontWeight: FontWeight.w400),
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
                          bool isActive = index == enteredPasscode.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isActive
                                    ? Color(0xFF00B807)
                                    : Color.fromARGB(255, 212, 212, 212),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
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
                    // Error message if PIN is incorrect
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    // Reusable Keypad
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
