import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/features/auth/domain/repositories/authentication_repository.dart';
import 'package:flutter_instagram/screens/signup/features/signup/presentation/cubit/signup_cubit.dart';

import '../../widgets/error_dialog.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (_) => SignupCubit(
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: SignupScreen(),
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
            BlocConsumer<SignupCubit, SignupState>(listener: ((context, state) {
          if (state.status == SignupStatus.error) {
            showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                      content: state.errorMessage as String,
                    ));
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
                                const InputDecoration(hintText: 'Username'),
                            onChanged: (value) => context
                                .read<SignupCubit>()
                                .usernameChanged(value),
                            validator: (value) => value!.trim().isEmpty
                                ? 'Please enter a valid email'
                                : null,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration:
                                const InputDecoration(hintText: 'Email'),
                            onChanged: (value) =>
                                context.read<SignupCubit>().emailChanged(value),
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
                                .read<SignupCubit>()
                                .passwordChanged(value),
                            validator: (value) => value!.length < 6
                                ? 'Must be at least 6 characters.'
                                : null,
                          ),
                          const SizedBox(height: 28.0),
                          TextButton(
                            onPressed: () => _submitForm(
                              context,
                              state.status == SignupStatus.submitting,
                            ),
                            child: const Text('Sign Up'),
                          ),
                          const SizedBox(height: 12.0),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Back to Login'),
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
      context.read<SignupCubit>().signUpWithCrentials();
    }
  }
}
