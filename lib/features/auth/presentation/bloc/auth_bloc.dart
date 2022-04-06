import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_instagram/features/auth/domain/entities/user_entity.dart';

// import 'package:flutter_instagram/repositories/auth/auth_repository.dart';

import '../../domain/repositories/authentication_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthState.unknown()) {
    on<AuthUserChanged>(_onAuthUserChangedToState);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    _userSubscription = _authenticationRepository.user
        .listen((user) => add(AuthUserChanged(user: user)));
  }
  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<User> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  void _onAuthUserChangedToState(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(event.user.isNotEmpty
        ? AuthState.authenticated(event.user)
        : const AuthState.unauthenticated());
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    unawaited(_authenticationRepository.logOut());
  }
}
