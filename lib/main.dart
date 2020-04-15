import 'package:cloud_firestore/cloud_firestore.dart';
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prova Firestore')),
      body: FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection('proves').document('test1').get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            // El Future encara s'ha de resoldre
            return Center(child: CircularProgressIndicator());
          }
          final DocumentSnapshot doc = snapshot.data;
          Map<String, dynamic> fields = doc.data;
          return Center(
            child: Text(fields['text']),
          );
        }
      ),
    );
  }
}
