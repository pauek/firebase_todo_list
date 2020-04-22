import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/db.dart';
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

// DocumentSnapshot: "Foto" d'un document en un cert instant de temps.
// QuerySnapshot: "Foto" d'un consulta a una col·lecció.

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Todo List')),
      body: StreamBuilder<List<Todo>>(
          stream: todoListSnapshots(),
          builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('ERROR: ${snapshot.error.toString()}'));
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return TodoList(todos: snapshot.data);
              case ConnectionState.done:
                return Center(child: Text("done??"));
              case ConnectionState.none:
              default:
                return Center(child: Text("no hi ha stream??"));
            }
          }),
    );
  }
}

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  TodoList({@required this.todos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, int index) {
        return ListTile(
          onTap: () {
            Firestore.instance
                .collection('todos')
                .document(todos[index].id)
                .updateData({
              'done': !todos[index].done,
              'parida': 'Feta!',
            });
          },
          title: Text(todos[index].what),
          leading: Checkbox(
            value: todos[index].done,
            onChanged: (newValue) {
              Firestore.instance
                  .collection('todos')
                  .document(todos[index].id)
                  .updateData({
                'done': newValue,
                'parida': 'Feta!',
              });
            },
          ),
        );
      },
    );
  }
}
