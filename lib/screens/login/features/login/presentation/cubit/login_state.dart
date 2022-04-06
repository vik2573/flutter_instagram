part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    this.errorMessage,
  });

  final String email;
  final String password;
  final LoginStatus status;
  final String? errorMessage;

  bool get isFormValue => email.isNotEmpty && password.isNotEmpty;

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
      errorMessage: '',
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        email,
        password,
        status,
      ];

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
