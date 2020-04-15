import 'package:flutter/material.dart';

void main() => runApp(FirebaseApp());

class FirebaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: Placeholder()),
    );
  }
}
