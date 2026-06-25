import 'package:dartz/dartz.dart' as dartz;
import 'package:taski/core/errors/failures.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/tasks/domain/repositories/tasks_repository.dart';

class DeleteTask implements UseCase<void, DeleteTaskParams> {
  final TasksRepository repository;

  DeleteTask(this.repository);

  @override
  Future<dartz.Either<Failure, void>> call(DeleteTaskParams params) async {
    return await repository.deleteTask(params.taskId);
  }
}

class DeleteTaskParams {
  final String taskId;

  DeleteTaskParams({required this.taskId});
}