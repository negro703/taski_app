import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:taski/core/errors/failures.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';
import 'package:taski/features/tasks/domain/repositories/tasks_repository.dart';

class UpdateTaskStatus implements UseCase<void, UpdateTaskStatusParams> {
  final TasksRepository repository;

  UpdateTaskStatus(this.repository);

  @override
  Future<dartz.Either<Failure, void>> call(UpdateTaskStatusParams params) async {
    return await repository.updateTaskStatus(params.taskId, params.status);
  }
}

class UpdateTaskStatusParams extends Equatable {
  final String taskId;
  final TaskStatus status;

  const UpdateTaskStatusParams({
    required this.taskId,
    required this.status,
  });

  @override
  List<Object?> get props => [taskId, status];
}
