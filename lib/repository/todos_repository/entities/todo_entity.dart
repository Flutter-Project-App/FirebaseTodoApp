import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final String id;
  final bool complete;
  final String task;
  final String? note;

  TodoEntity(
      {required this.id,
      required this.complete,
      required this.task,
      this.note});

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "complete": complete,
      "task": task,
      "note": note,
    };
  }

  @override
  List<Object?> get props => [id, complete, task, note];

  @override
  String toString() {
    return 'TodoEntity { complete: $complete, task: $task, note: $note, id: $id }';
  }

  static TodoEntity fromJson(Map<String, Object> json) {
    return TodoEntity(
        id: json["id"] as String,
        complete: json["complete"] as bool,
        task: json["task"] as String,
        note: json["note"] as String);
  }

  static TodoEntity fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    if (data == null) throw Exception();
    return TodoEntity(
        id: snapshot['id'],
        complete: snapshot["complete"],
        task: snapshot["task"],
        note: snapshot["note"]);
  }

  Map<String, Object?> toDocument() {
    return {'id': id, 'complete': complete, 'task': task, 'note': note};
  }
}
