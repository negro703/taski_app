import 'dart:async';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
import 'package:taski/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:taski/features/tasks/presentation/bloc/tasks_event.dart';
import 'package:taski/features/tasks/presentation/bloc/tasks_state.dart';

class MockGetProjects extends Mock implements GetProjects {}
class MockCreateProject extends Mock implements CreateProject {}
class MockDeleteProject extends Mock implements DeleteProject {}
class MockGetTasks extends Mock implements GetTasks {}
class MockCreateTask extends Mock implements CreateTask {}
class MockDeleteTask extends Mock implements DeleteTask {}
class MockUpdateTaskStatus extends Mock implements UpdateTaskStatus {}

void main() {
  late MockGetProjects mockGetProjects;
  late MockCreateProject mockCreateProject;
  late MockDeleteProject mockDeleteProject;
  late MockGetTasks mockGetTasks;
  late MockCreateTask mockCreateTask;
  late MockDeleteTask mockDeleteTask;
  late MockUpdateTaskStatus mockUpdateTaskStatus;
  late TasksBloc tasksBloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const GetTasksParams(projectId: 'test'));
  });

  setUp(() {
    mockGetProjects = MockGetProjects();
    mockCreateProject = MockCreateProject();
    mockDeleteProject = MockDeleteProject();
    mockGetTasks = MockGetTasks();
    mockCreateTask = MockCreateTask();
    mockDeleteTask = MockDeleteTask();
    mockUpdateTaskStatus = MockUpdateTaskStatus();

    tasksBloc = TasksBloc(
      getProjects: mockGetProjects,
      createProject: mockCreateProject,
      deleteProject: mockDeleteProject,
      getTasks: mockGetTasks,
      createTask: mockCreateTask,
      deleteTask: mockDeleteTask,
      updateTaskStatus: mockUpdateTaskStatus,
    );
  });

  tearDown(() {
    tasksBloc.close();
  });

  group('TasksBloc GetProjectsEvent', () {
    const tProject1 = Project(
      id: '1',
      name: 'Project 1',
      createdBy: 'user1',
      members: ['user1'],
    );
    const tProject2 = Project(
      id: '2',
      name: 'Project 2',
      createdBy: 'user1',
      members: ['user1'],
    );
    final tProjects = [tProject1, tProject2];

    test('should emit [ProjectsLoading, ProjectsLoaded] when projects are fetched successfully',
        () async {
      // Arrange
      final streamController = StreamController<dartz.Either<Failure, List<Project>>>();
      when(() => mockGetProjects(any())).thenAnswer((_) => streamController.stream);

      // Act
      tasksBloc.add(GetProjectsEvent());

      // Assert: initial state
      expect(tasksBloc.state, isA<TasksInitial>());

      // Small delay to let the bloc process the event
      await Future.delayed(const Duration(milliseconds: 50));
      expect(tasksBloc.state, isA<ProjectsLoading>());

      // Emit success
      streamController.add(dartz.Right(tProjects));
      await Future.delayed(const Duration(milliseconds: 50));

      // Assert final loaded state
      expect(tasksBloc.state, isA<ProjectsLoaded>());
      expect((tasksBloc.state as ProjectsLoaded).projects, tProjects);

      await streamController.close();
    });

    test('should emit [ProjectsLoading, ProjectsError] when fetching projects fails',
        () async {
      // Arrange
      final streamController = StreamController<dartz.Either<Failure, List<Project>>>();
      when(() => mockGetProjects(any())).thenAnswer((_) => streamController.stream);

      // Act
      tasksBloc.add(GetProjectsEvent());

      // Assert: loading state
      await Future.delayed(const Duration(milliseconds: 50));
      expect(tasksBloc.state, isA<ProjectsLoading>());

      // Emit failure
      streamController.add(dartz.Left(ServerFailure(message: 'Server error')));
      await Future.delayed(const Duration(milliseconds: 50));

      // Assert final error state
      expect(tasksBloc.state, isA<ProjectsError>());
      expect((tasksBloc.state as ProjectsError).message, 'Server Failure');

      await streamController.close();
    });
  });

  group('TasksBloc GetTasksEvent', () {
    final tTask1 = Task(
      id: '1',
      projectId: 'proj1',
      title: 'Task 1',
      description: 'Description 1',
      status: TaskStatus.todo,
      dueDate: DateTime(2026, 6, 25),
      assignedTo: 'user1',
      createdAt: DateTime(2026, 6, 25),
    );
    final tTask2 = Task(
      id: '2',
      projectId: 'proj1',
      title: 'Task 2',
      description: 'Description 2',
      status: TaskStatus.inProgress,
      dueDate: DateTime(2026, 6, 25),
      assignedTo: 'user1',
      createdAt: DateTime(2026, 6, 25),
    );
    final tTasks = [tTask1, tTask2];

    test('should emit [TasksLoading, TasksLoaded] when tasks are fetched successfully',
        () async {
      // Arrange
      final streamController = StreamController<dartz.Either<Failure, List<Task>>>();
      when(() => mockGetTasks(any())).thenAnswer((_) => streamController.stream);

      // Act
      tasksBloc.add(const GetTasksEvent(projectId: 'proj1'));

      // Assert: loading state
      await Future.delayed(const Duration(milliseconds: 50));
      expect(tasksBloc.state, isA<TasksLoading>());

      // Emit success
      streamController.add(dartz.Right(tTasks));
      await Future.delayed(const Duration(milliseconds: 50));

      // Assert final loaded state
      expect(tasksBloc.state, isA<TasksLoaded>());
      expect((tasksBloc.state as TasksLoaded).tasks, tTasks);

      await streamController.close();
    });

    test('should emit [TasksLoading, TasksError] when fetching tasks fails',
        () async {
      // Arrange
      final streamController = StreamController<dartz.Either<Failure, List<Task>>>();
      when(() => mockGetTasks(any())).thenAnswer((_) => streamController.stream);

      // Act
      tasksBloc.add(const GetTasksEvent(projectId: 'proj1'));

      // Assert: loading state
      await Future.delayed(const Duration(milliseconds: 50));
      expect(tasksBloc.state, isA<TasksLoading>());

      // Emit failure
      streamController.add(dartz.Left(CacheFailure(message: 'Cache error')));
      await Future.delayed(const Duration(milliseconds: 50));

      // Assert final error state
      expect(tasksBloc.state, isA<TasksError>());
      expect((tasksBloc.state as TasksError).message, 'Cache Failure');

      await streamController.close();
    });
  });
}