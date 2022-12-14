part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthNotLoggedInState extends AuthState {}

class AuthLoggingInState extends AuthState {}

class AuthLoggedInState extends AuthState {}

class AuthRefreshedState extends AuthState {}

class AuthErrorState extends AuthState {}

class AuthLoggedOutState extends AuthState {}
