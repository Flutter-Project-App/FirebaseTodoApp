import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_todoapp/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:firebase_todoapp/blocs/authentication_bloc/authentication_event.dart';
import 'package:firebase_todoapp/blocs/todos/todos_bloc.dart';
import 'package:firebase_todoapp/blocs/todos/todos_event.dart';
import 'package:firebase_todoapp/repository/todos_repository/firebase_todos_repository.dart';
import 'package:firebase_todoapp/repository/user_repository/firebase_user_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application.dart';
import 'blocs/authentication_bloc/authentication_state.dart';
import 'blocs/simple_bloc_observer.dart';
import 'screens/add_edit_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp();
  runApp(TodosApp());
}

class TodosApp extends StatelessWidget {
  const TodosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(create: (context) {
            return AuthenticationBloc(userRepository: FirebaseUserRepository())
              ..add(AppStarted());
          }),
          BlocProvider<TodosBloc>(create: (context) {
            return TodosBloc(todosRepository: FirebaseTodosRepository())
              ..add(LoadTodos());
          })
        ],
        child: MaterialApp(
          title: 'Todos App',
          routes: {
            '/': (context) {
              return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return MultiBlocProvider(providers: [

                      ], child: HomeScreen());
                    }
                    if (state is Unauthenticated) {
                      return Center(child: Text('Could not authenticate with Firestore'),);
                    }
                    return Center(child: CircularProgressIndicator(),);
                  });
            },
            '/addTodo': (context) {
              return AddEditScreen(

              );
            }
          },
        ));
  }
}
