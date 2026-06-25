import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/usecases/usecase.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/register_with_email.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/watch_auth_state.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.watchAuthState,
    required this.signInWithEmail,
    required this.registerWithEmail,
    required this.signOut,
  }) : super(const AuthState()) {
    on<AuthSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthSignInSubmitted>(_onSignInSubmitted);
    on<AuthRegisterSubmitted>(_onRegisterSubmitted);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  final WatchAuthState watchAuthState;
  final SignInWithEmail signInWithEmail;
  final RegisterWithEmail registerWithEmail;
  final SignOut signOut;

  Future<void> _onSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach<AuthUser?>(
      watchAuthState(),
      onData: (user) {
        if (user == null) {
          emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              clearUser: true,
              clearError: true,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            clearError: true,
          ),
        );
      },
      onError: (_, _) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: 'Unable to read the current session.',
          ),
        );
      },
    );
  }

  Future<void> _onSignInSubmitted(
    AuthSignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      await signInWithEmail(
        SignInWithEmailParams(email: event.email, password: event.password),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRegisterSubmitted(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      await registerWithEmail(
        RegisterWithEmailParams(
          displayName: event.displayName,
          email: event.email,
          password: event.password,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    await signOut(const NoParams());
  }
}
