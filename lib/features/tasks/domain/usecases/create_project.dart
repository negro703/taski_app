import 'package:dartz/dartz.dart' as dartz;
import 'package:taski/core/errors/failures.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/tasks/domain/entities/project.dart';
import 'package:taski/features/tasks/domain/repositories/tasks_repository.dart';

class CreateProject implements UseCase<Project, CreateProjectParams> {
  final TasksRepository repository;

  CreateProject(this.repository);

  @override
  Future<dartz.Either<Failure, Project>> call(CreateProjectParams params) async {
    return await repository.createProject(params.project);
  }
}

class CreateProjectParams {
  final Project project;

  CreateProjectParams({required this.project});
}
