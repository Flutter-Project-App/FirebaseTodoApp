import 'dart:async';

import 'models/todo.dart';

abstract class TodosRepository {
  Future<void> addNewTodo(Todo todo);

  Future<void> deleteTodo(Todo todo);

  Future<void> updateTodo(Todo todo);

  Stream<List<Todo>> todos();
}
