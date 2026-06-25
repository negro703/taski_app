import 'package:equatable/equatable.dart';

enum TaskStatus { todo, inProgress, done }

class Task extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime dueDate;
  final String assignedTo;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
    required this.assignedTo,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, projectId, title, description, status, dueDate, assignedTo, createdAt];
}