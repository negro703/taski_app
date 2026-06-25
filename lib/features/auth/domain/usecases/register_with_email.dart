import '../../../../core/utils/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../repository_interfaces/auth_repository.dart';

class RegisterWithEmail implements UseCase<AuthUser, RegisterWithEmailParams> {
  const RegisterWithEmail(this._repository);

  final AuthRepository _repository;

  @override
  Future<AuthUser> call(RegisterWithEmailParams params) {
    return _repository.registerWithEmailAndPassword(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
    );
  }
}

class RegisterWithEmailParams {
  const RegisterWithEmailParams({
    required this.email,
    required this.password,
    required this.displayName,
  });

  final String email;
  final String password;
  final String displayName;
}
