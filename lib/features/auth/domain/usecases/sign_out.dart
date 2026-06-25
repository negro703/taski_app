import '../../../../core/utils/usecases/usecase.dart';
import '../repository_interfaces/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  const SignOut(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(NoParams params) {
    return _repository.signOut();
  }
}
