import 'package:dartz/dartz.dart' as dartz;
import 'package:taski/core/errors/failures.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/tasks/domain/repositories/tasks_repository.dart';

class DeleteProject implements UseCase<void, DeleteProjectParams> {
  final TasksRepository repository;

  DeleteProject(this.repository);

  @override
  Future<dartz.Either<Failure, void>> call(DeleteProjectParams params) async {
    return await repository.deleteProject(params.projectId);
  }
}

class DeleteProjectParams {
  final String projectId;

  DeleteProjectParams({required this.projectId});
}