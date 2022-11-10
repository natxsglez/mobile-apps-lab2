import 'dart:async';

import 'package:birds_museum/bloc/auth_bloc/auth_repository.dart';
import 'package:birds_museum/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  UserModel? _currUser;
  UserModel? get currUser => _currUser;

  AuthBloc({required this.authRepository}) : super(AuthNotLoggedInState()) {
    on<AuthEvent>(_checkLoginStatusEvent);
    on<AuthGoogleLoginEvent>(_loginWithGoogle);
  }

  FutureOr<void> _checkLoginStatusEvent(event, emit) async {
    UserModel? user = await authRepository.getMeUser();
    if (user != null) {
      _currUser = user;
      emit(AuthLoggedInState());
    }
  }

  FutureOr<void> _loginWithGoogle(event, emit) async {
    try {
      final user = await authRepository.signInWithGoogle();
      emit(AuthLoggedInState());
    } catch (error) {
      emit(AuthNotLoggedInState());
    }
  }
}
