import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:taski/core/errors/failures.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';
import 'package:taski/features/tasks/domain/repositories/tasks_repository.dart';

class GetTasks implements StreamUseCase<List<Task>, GetTasksParams> {
  final TasksRepository repository;

  GetTasks(this.repository);

  @override
  Stream<dartz.Either<Failure, List<Task>>> call(GetTasksParams params) {
    return repository.getTasks(params.projectId);
  }
}

class GetTasksParams extends Equatable {
  final String projectId;

  const GetTasksParams({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}
