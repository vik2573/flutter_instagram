import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/features/auth/domain/repositories/authentication_repository.dart';
import 'package:flutter_instagram/screens/login/features/login/presentation/cubit/login_cubit.dart';
import 'package:flutter_instagram/widgets/error_dialog.dart';

import '../signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) => LoginCubit(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: LoginScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child:
            BlocConsumer<LoginCubit, LoginState>(listener: ((context, state) {
          if (state.status == LoginStatus.error) {
            showDialog(
              context: context,
              builder: (context) =>
                  ErrorDialog(content: state.errorMessage as String),
            );
          }
        }), builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            'Instagram',
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            decoration:
                                const InputDecoration(hintText: 'Email'),
                            onChanged: (value) =>
                                context.read<LoginCubit>().emailChanged(value),
                            validator: (value) => !value!.contains('@')
                                ? 'Please enter a valid email'
                                : null,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration:
                                const InputDecoration(hintText: 'Password'),
                            obscureText: true,
                            onChanged: (value) => context
                                .read<LoginCubit>()
                                .passwordChanged(value),
                            validator: (value) => value!.length < 6
                                ? 'Must be at least 6 characters.'
                                : null,
                          ),
                          const SizedBox(height: 28.0),
                          TextButton(
                            onPressed: () => _submitForm(
                              context,
                              state.status == LoginStatus.submitting,
                            ),
                            child: const Text('log In'),
                          ),
                          const SizedBox(height: 12.0),
                          TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(SignupScreen.routeName),
                            child: const Text('No account? Sign up'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCrentials();
    }
  }
}
