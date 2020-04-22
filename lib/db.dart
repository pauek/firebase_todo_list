
import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String what;
  bool done;
  
  Todo(this.what, [this.done = false]);
  Todo.fromFirestore(DocumentSnapshot doc) {
    id = doc.documentID;
    what = doc.data['what'];
    done = doc.data['done'];
  }
}

Stream<List<Todo>> todoListSnapshots() {
  return Firestore.instance.collection('todos').snapshots().map((QuerySnapshot query) {
    final List<DocumentSnapshot> docs = query.documents;
    return docs.map((doc) => Todo.fromFirestore(doc)).toList();
  });
}

addTodo(String text) {
  /*
  Firestore.instance.collection('todos').document().setData({
    'what': text,
    'done': false,
  });
  */
  Firestore.instance.collection('todos').add({
    'what': text,
    'done': false,
  });
}
