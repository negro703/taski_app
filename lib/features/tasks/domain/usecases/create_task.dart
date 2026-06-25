import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:taski/core/errors/failures.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/tasks/domain/entities/task.dart';
import 'package:taski/features/tasks/domain/repositories/tasks_repository.dart';

class CreateTask implements UseCase<Task, CreateTaskParams> {
  final TasksRepository repository;

  CreateTask(this.repository);

  @override
  Future<dartz.Either<Failure, Task>> call(CreateTaskParams params) async {
    return await repository.createTask(params.task);
  }
}

class CreateTaskParams extends Equatable {
  final Task task;

  const CreateTaskParams({required this.task});

  @override
  List<Object?> get props => [task];
}
