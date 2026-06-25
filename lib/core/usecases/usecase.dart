import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:taski/core/errors/failures.dart';

abstract class UseCase<ReturnType, Params> {
  Future<dartz.Either<Failure, ReturnType>> call(Params params);
}

abstract class StreamUseCase<ReturnType, Params> {
  Stream<dartz.Either<Failure, ReturnType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}