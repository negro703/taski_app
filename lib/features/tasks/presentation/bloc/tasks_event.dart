import 'package:equatable/equatable.dart';
import 'package:taski/features/tasks/domain/entities/project.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';

/// Events for the TasksBloc
abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

/// Fired to load all projects
class GetProjectsEvent extends TasksEvent {}

/// Fired to create a new project
class CreateProjectEvent extends TasksEvent {
  final Project project;

  const CreateProjectEvent({required this.project});

  @override
  List<Object> get props => [project];
}

/// Fired to delete a project
class DeleteProjectEvent extends TasksEvent {
  final String projectId;

  const DeleteProjectEvent({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

/// Fired to load tasks for a given project
class GetTasksEvent extends TasksEvent {
  final String projectId;

  const GetTasksEvent({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

/// Fired to create a new task
class CreateTaskEvent extends TasksEvent {
  final Task task;

  const CreateTaskEvent({required this.task});

  @override
  List<Object> get props => [task];
}

/// Fired to delete a task
class DeleteTaskEvent extends TasksEvent {
  final String taskId;
  final String projectId;

  const DeleteTaskEvent({required this.taskId, required this.projectId});

  @override
  List<Object> get props => [taskId, projectId];
}

/// Fired to update a task's status
class UpdateTaskStatusEvent extends TasksEvent {
  final String taskId;
  final String projectId;
  final TaskStatus status;

  const UpdateTaskStatusEvent({
    required this.taskId,
    required this.projectId,
    required this.status,
  });

  @override
  List<Object> get props => [taskId, projectId, status];
}