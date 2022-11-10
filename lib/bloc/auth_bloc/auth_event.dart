part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckLoginStatusEvent extends AuthEvent {}

class AuthGoogleLoginEvent extends AuthEvent {}

class AuthGoogleLogoutEvent extends AuthEvent {}

class RefreshUserDataEvent extends AuthEvent {}
