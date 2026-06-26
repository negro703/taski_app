import 'package:dartz/dartz.dart' as dartz;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taski/core/errors/failures.dart';
import 'package:taski/features/tasks/data/datasources/tasks_local_data_source.dart';
import 'package:taski/features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:taski/features/tasks/data/models/project_model.dart';
import 'package:taski/features/tasks/data/models/task_model.dart';
import 'package:taski/features/tasks/domain/entities/project.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';
import 'package:taski/features/tasks/domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;
  final TasksLocalDataSource localDataSource;

  TasksRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  @override
  Stream<dartz.Either<Failure, List<Project>>> getProjects() async* {
    try {
      final cached = await localDataSource.getCachedProjects();
      if (cached.isNotEmpty) {
        yield dartz.Right<Failure, List<Project>>(cached);
      }
    } catch (_) {}

    try {
      await for (final models in remoteDataSource.getProjects()) {
        try {
          await localDataSource.cacheProjects(models);
        } catch (_) {}
        yield dartz.Right<Failure, List<Project>>(
          models.map((m) => m as Project).toList(),
        );
      }
    } catch (e) {
      try {
        final cached = await localDataSource.getCachedProjects();
        if (cached.isNotEmpty) {
          yield dartz.Right<Failure, List<Project>>(cached);
        } else {
          yield dartz.Left<Failure, List<Project>>(ServerFailure());
        }
      } catch (_) {
        yield dartz.Left<Failure, List<Project>>(ServerFailure());
      }
    }
  }

  @override
  Future<dartz.Either<Failure, Project>> createProject(Project project) async {
    try {
      final userId = _currentUserId ?? '';
      final projectModel = ProjectModel(
        id: project.id,
        name: project.name,
        createdBy: project.createdBy,
        members: project.members,
        userId: userId,
      );
      final newId = await remoteDataSource.createProject(projectModel);
      final createdModel = ProjectModel(
        id: newId,
        name: project.name,
        createdBy: project.createdBy,
        members: project.members,
        userId: userId,
      );
      // Cache locally after remote creation
      try {
        final existing = await localDataSource.getCachedProjects();
        existing.add(createdModel);
        await localDataSource.cacheProjects(existing);
      } catch (_) {}
      return dartz.Right(createdModel as Project);
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, void>> deleteProject(String projectId) async {
    try {
      await remoteDataSource.deleteProject(projectId);
      try {
        await localDataSource.removeCachedProject(projectId);
      } catch (_) {}
      return dartz.Right(null);
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Stream<dartz.Either<Failure, List<Task>>> getTasks(String projectId) async* {
    try {
      final cached = await localDataSource.getCachedTasks(projectId);
      if (cached.isNotEmpty) {
        yield dartz.Right<Failure, List<Task>>(cached);
      }
    } catch (_) {}

    try {
      await for (final models in remoteDataSource.getTasks(projectId)) {
        try {
          await localDataSource.cacheTasks(models);
        } catch (_) {}
        yield dartz.Right<Failure, List<Task>>(
          models.map((m) => m as Task).toList(),
        );
      }
    } catch (e) {
      try {
        final cached = await localDataSource.getCachedTasks(projectId);
        if (cached.isNotEmpty) {
          yield dartz.Right<Failure, List<Task>>(cached);
        } else {
          yield dartz.Left<Failure, List<Task>>(ServerFailure());
        }
      } catch (_) {
        yield dartz.Left<Failure, List<Task>>(ServerFailure());
      }
    }
  }

  @override
  Future<dartz.Either<Failure, Task>> createTask(Task task) async {
    try {
      final userId = _currentUserId ?? '';
      final taskModel = TaskModel(
        id: task.id,
        projectId: task.projectId,
        title: task.title,
        description: task.description,
        status: task.status,
        dueDate: task.dueDate,
        assignedTo: task.assignedTo,
        createdAt: task.createdAt,
        userId: userId,
      );
      // Write to remote first - Firestore generates the ID
      final newId = await remoteDataSource.createTask(taskModel);
      // Create the model with the real Firestore ID
      final createdModel = TaskModel(
        id: newId,
        projectId: task.projectId,
        title: task.title,
        description: task.description,
        status: task.status,
        dueDate: task.dueDate,
        assignedTo: task.assignedTo,
        createdAt: task.createdAt,
        userId: userId,
      );
      // Immediately cache locally so the UI has it
      try {
        final existing = await localDataSource.getCachedTasks(task.projectId);
        existing.add(createdModel);
        await localDataSource.cacheTasks(existing);
      } catch (_) {}
      return dartz.Right(createdModel as Task);
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await remoteDataSource.deleteTask(taskId);
      try {
        await localDataSource.removeCachedTask(taskId);
      } catch (_) {}
      return dartz.Right(null);
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }

  @override
  Future<dartz.Either<Failure, void>> updateTaskStatus(
      String taskId, TaskStatus status) async {
    try {
      await remoteDataSource.updateTaskStatus(taskId, status);
      return dartz.Right(null);
    } catch (e) {
      return dartz.Left(ServerFailure());
    }
  }
}