import 'package:cady/security/create_passcode.dart';
import 'package:cady/security/enter_passcode.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreatePasscode(),
    );
  }
}
