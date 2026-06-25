import 'package:dartz/dartz.dart';
import 'package:taski/core/errors/failures.dart';
import 'package:taski/core/usecases/usecase.dart';
import 'package:taski/features/tasks/domain/entities/project.dart';
import 'package:taski/features/tasks/domain/repositories/tasks_repository.dart';

class GetProjects implements StreamUseCase<List<Project>, NoParams> {
  final TasksRepository repository;

  GetProjects(this.repository);

  @override
  Stream<Either<Failure, List<Project>>> call(NoParams params) {
    return repository.getProjects();
  }
}
