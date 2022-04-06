import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../error/failure.dart';
import '../../../../../../features/auth/domain/repositories/authentication_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(SignupState.initial());

  final AuthenticationRepository _authenticationRepository;

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, status: SignupStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  Future<void> signUpWithCrentials() async {
    if (!state.isFormValue || state.status == SignupStatus.submitting) return;
    emit(
      state.copyWith(status: SignupStatus.submitting),
    );
    try {
      await _authenticationRepository.singUpWithEmailAndPassword(
        username: state.username,
        email: state.email,
        password: state.password,
      );
      emit(
        state.copyWith(
          status: SignupStatus.success,
        ),
      );
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
        ),
      );
    }
  }
}
