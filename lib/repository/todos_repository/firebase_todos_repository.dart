import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todoapp/repository/todos_repository/models/todo.dart';

import 'entities/todo_entity.dart';
import 'todos_repository.dart';

class FirebaseTodosRepository implements TodosRepository {
  final todoCollection = FirebaseFirestore.instance.collection('todos');

  @override
  Future<void> addNewTodo(Todo todo) {
    return todoCollection.doc(todo.id).set((todo.toEntity()).toDocument());
  }

  @override
  Future<void> deleteTodo(Todo todo) {
    return todoCollection.doc(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return todoCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => Todo.fromEntity(TodoEntity.fromSnapshot(e))).toList();
    });
  }

  @override
  Future<void> updateTodo(Todo todo) {
    return todoCollection.doc(todo.id).update(todo.toEntity().toDocument());
  }

}