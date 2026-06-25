import 'package:equatable/equatable.dart';
import 'package:taski/features/tasks/domain/entities/project.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';

/// States for the TasksBloc
abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

/// Initial state before any data is loaded
class TasksInitial extends TasksState {}

/// Projects are being loaded
class ProjectsLoading extends TasksState {}

/// Projects loaded successfully
class ProjectsLoaded extends TasksState {
  final List<Project> projects;

  const ProjectsLoaded({required this.projects});

  @override
  List<Object> get props => [projects];
}

/// Projects loading error
class ProjectsError extends TasksState {
  final String message;

  const ProjectsError({required this.message});

  @override
  List<Object> get props => [message];
}

/// A project was created successfully
class ProjectCreated extends TasksState {
  final Project project;

  const ProjectCreated({required this.project});

  @override
  List<Object> get props => [project];
}

/// A project was deleted successfully
class ProjectDeleted extends TasksState {
  final String projectId;

  const ProjectDeleted({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

/// Tasks are being loaded
class TasksLoading extends TasksState {}

/// Tasks loaded successfully
class TasksLoaded extends TasksState {
  final List<Task> tasks;

  const TasksLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

/// Tasks loading error
class TasksError extends TasksState {
  final String message;

  const TasksError({required this.message});

  @override
  List<Object> get props => [message];
}

/// A task was created successfully
class TaskCreated extends TasksState {
  final Task task;

  const TaskCreated({required this.task});

  @override
  List<Object> get props => [task];
}

/// A task was deleted successfully
class TaskDeleted extends TasksState {
  final String taskId;

  const TaskDeleted({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

/// A task's status was updated
class TaskStatusUpdated extends TasksState {
  final String taskId;
  final TaskStatus status;

  const TaskStatusUpdated({required this.taskId, required this.status});

  @override
  List<Object> get props => [taskId, status];
}