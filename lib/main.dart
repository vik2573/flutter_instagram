import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_instagram/features/auth/simple_bloc_observer.dart';
import 'package:flutter_instagram/repositories/user/user_repository.dart';
// import 'package:flutter_instagram/repositories/auth/auth_repository.dart';
import 'package:flutter_instagram/screens/splash/splash_screen.dart';

import 'config/custom_router.dart';
import 'features/auth/domain/repositories/authentication_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  BlocOverrides.runZoned(
    () {
      // CounterCubit()
      // ..increment()
      // ..close();
    },
    blocObserver: SimpleBlocObserver(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // context.read<AuthRepository>();
    AuthenticationRepository().logOut();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => AuthenticationRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
                authenticationRepository:
                    context.read<AuthenticationRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Instagram',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              toolbarTextStyle:
                  const TextTheme(headline6: TextStyle(color: Colors.black))
                      .bodyText2,
              titleTextStyle: const TextTheme(
                  headline6: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              )).headline6,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
        ),
      ),
    );
  }
}
