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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = new TextEditingController();

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
              return _buildBody(snapshot.data);
            case ConnectionState.done:
              return Center(child: Text("done??"));
            case ConnectionState.none:
            default:
              return Center(child: Text("no hi ha stream??"));
          }
        },
      ),
    );
  }

  Widget _buildBody(List<Todo> todos) {
    return Column(
      children: <Widget>[
        Expanded(child: TodoList(todos: todos)),
        Material(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addTodo(_controller.text);
                    _controller.clear();
                  }
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  TodoList({@required this.todos});

  _toggleDone(Todo todo) {
    Firestore.instance.collection('todos').document(todo.id).updateData({
      'done': !todo.done,
      'parida': 'Feta!',
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, int index) {
        return ListTile(
          onTap: () => _toggleDone(todos[index]),
          title: Text(todos[index].what),
          leading: Checkbox(
            value: todos[index].done,
            onChanged: (_) => _toggleDone(todos[index]),
          ),
        );
      },
    );
  }
}
