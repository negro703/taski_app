import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:taski/core/errors/failures.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/tasks/domain/entities/project.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';
import 'package:taski/features/tasks/domain/usecases/create_project.dart';
import 'package:taski/features/tasks/domain/usecases/create_task.dart';
import 'package:taski/features/tasks/domain/usecases/delete_project.dart';
import 'package:taski/features/tasks/domain/usecases/delete_task.dart';
import 'package:taski/features/tasks/domain/usecases/get_projects.dart';
import 'package:taski/features/tasks/domain/usecases/get_tasks.dart';
import 'package:taski/features/tasks/domain/usecases/update_task_status.dart';
import 'package:taski/features/tasks/presentation/bloc/tasks_event.dart';
import 'package:taski/features/tasks/presentation/bloc/tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetProjects getProjects;
  final CreateProject createProject;
  final DeleteProject deleteProject;
  final GetTasks getTasks;
  final CreateTask createTask;
  final DeleteTask deleteTask;
  final UpdateTaskStatus updateTaskStatus;

  TasksBloc({
    required this.getProjects,
    required this.createProject,
    required this.deleteProject,
    required this.getTasks,
    required this.createTask,
    required this.deleteTask,
    required this.updateTaskStatus,
  }) : super(TasksInitial()) {
    on<GetProjectsEvent>(_onGetProjects);
    on<CreateProjectEvent>(_onCreateProject);
    on<DeleteProjectEvent>(_onDeleteProject);
    on<GetTasksEvent>(_onGetTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
  }

  Future<void> _onGetProjects(GetProjectsEvent event, Emitter<TasksState> emit) async {
    emit(ProjectsLoading());
    await emit.forEach<dartz.Either<Failure, List<Project>>>(
      getProjects(NoParams()),
      onData: (either) => either.fold(
        (failure) => ProjectsError(message: _mapFailureToMessage(failure)),
        (projects) => ProjectsLoaded(projects: projects),
      ),
      onError: (error, stacktrace) => ProjectsError(message: error.toString()),
    );
  }

  Future<void> _onCreateProject(
      CreateProjectEvent event, Emitter<TasksState> emit) async {
    final result = await createProject(CreateProjectParams(project: event.project));
    result.fold(
      (failure) => emit(ProjectsError(message: _mapFailureToMessage(failure))),
      (_) => add(GetProjectsEvent()),
    );
  }

  Future<void> _onDeleteProject(
      DeleteProjectEvent event, Emitter<TasksState> emit) async {
    final result = await deleteProject(DeleteProjectParams(projectId: event.projectId));
    result.fold(
      (failure) => emit(ProjectsError(message: _mapFailureToMessage(failure))),
      (_) => add(GetProjectsEvent()),
    );
  }

  Future<void> _onGetTasks(GetTasksEvent event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    await emit.forEach<dartz.Either<Failure, List<Task>>>(
      getTasks(GetTasksParams(projectId: event.projectId)),
      onData: (either) => either.fold(
        (failure) => TasksError(message: _mapFailureToMessage(failure)),
        (tasks) => TasksLoaded(tasks: tasks),
      ),
      onError: (error, stacktrace) => TasksError(message: error.toString()),
    );
  }

  Future<void> _onCreateTask(CreateTaskEvent event, Emitter<TasksState> emit) async {
    final result = await createTask(CreateTaskParams(task: event.task));
    result.fold(
      (failure) => emit(TasksError(message: _mapFailureToMessage(failure))),
      (_) => add(GetTasksEvent(projectId: event.task.projectId)),
    );
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TasksState> emit) async {
    final result = await deleteTask(DeleteTaskParams(taskId: event.taskId));
    result.fold(
      (failure) => emit(TasksError(message: _mapFailureToMessage(failure))),
      (_) => add(GetTasksEvent(projectId: event.projectId)),
    );
  }

  Future<void> _onUpdateTaskStatus(
      UpdateTaskStatusEvent event, Emitter<TasksState> emit) async {
    final result = await updateTaskStatus(
        UpdateTaskStatusParams(taskId: event.taskId, status: event.status));
    result.fold(
      (failure) => emit(TasksError(message: _mapFailureToMessage(failure))),
      (_) => add(GetTasksEvent(projectId: event.projectId)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return "Server Failure";
      case CacheFailure _:
        return "Cache Failure";
      default:
        return "Unexpected error";
    }
  }
}
