import 'package:dartz/dartz.dart' as dartz;
import 'package:taski/core/errors/failures.dart';
import 'package:taski/features/tasks/domain/entities/project.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';

abstract class TasksRepository {
  Stream<dartz.Either<Failure, List<Project>>> getProjects();
  Future<dartz.Either<Failure, Project>> createProject(Project project);
  Future<dartz.Either<Failure, void>> deleteProject(String projectId);
  Stream<dartz.Either<Failure, List<Task>>> getTasks(String projectId);
  Future<dartz.Either<Failure, Task>> createTask(Task task);
  Future<dartz.Either<Failure, void>> deleteTask(String taskId);
  Future<dartz.Either<Failure, void>> updateTaskStatus(String taskId, TaskStatus status);
}