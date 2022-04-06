import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import 'package:flutter_instagram/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_instagram/models/failure_model.dart';
import 'package:flutter_instagram/models/user_model.dart';
import 'package:flutter_instagram/repositories/user/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  ProfileBloc({
    required UserRepository userRepository,
    required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc,
        super(ProfileState.initial()) {
    on<ProfileLoadUser>(_mapProfileloadUserToState);
  }

  void _mapProfileloadUserToState(
    ProfileLoadUser event,
    Emitter<ProfileState> emit,
  ) async {
    state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.id == event.userId;
      emit(state.copyWith(
        user: user,
        isCurrentUser: isCurrentUser,
        status: ProfileStatus.loaded,
      ));
    } on PlatformException catch (err) {
      emit(
        throw Failure(
          code: err.code,
          message: err.message as String,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          failure: const Failure(message: 'We unable to load this profile.'),
        ),
      );
    }
  }
}
