import 'dart:async';
import 'package:firebase_todoapp/blocs/todos/todos_event.dart';
import 'package:firebase_todoapp/blocs/todos/todos_state.dart';
import 'package:firebase_todoapp/repository/todos_repository/models/todo.dart';
import 'package:firebase_todoapp/repository/todos_repository/todos_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
  }

  final TodosRepository _todosRepository;

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodosState> emit) {
    return emit.onEach<List<Todo>>(_todosRepository.todos(),
        onData: (todos) => add(TodosUpdate(todos)));
  }

  void _onAddTodo(AddTodo event, Emitter<TodosState> emit) {
    _todosRepository.addNewTodo(event.todo);
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodosState> emit) {
    _todosRepository.updateTodo(event.updatedTodo);
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodosState> emit) {
    _todosRepository.deleteTodo(event.todo);
  }

  void _onToggleAll(ToggleAll event, Emitter<TodosState> emit) {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final allComplete = currentState.todos.every((todo) => todo.complete);
      final List<Todo> updatedTodos = currentState.todos
          .map((todo) => todo.copyWith(complete: !allComplete))
          .toList();
      updatedTodos.forEach((updatedTodo) {
        _todosRepository.updateTodo(updatedTodo);
      });
    }
  }

  void _onClearCompleted(ClearCompleted event, Emitter<TodosState> emit) {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final allComplete = currentState.todos.every((todo) => todo.complete);
      final List<Todo> completedTodos = currentState.todos
          .map((todo) => todo.copyWith(complete: !allComplete))
          .toList();
      completedTodos.forEach((completedTodo) {
        _todosRepository.updateTodo(completedTodo);
      });
    }
  }

  void _onTodosUpdated(TodosUpdate event, Emitter<TodosState> emit) {
    emit(TodosLoaded(event.todos));
  }
}
