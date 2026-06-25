
import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:taski/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<dartz.Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<dartz.Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
