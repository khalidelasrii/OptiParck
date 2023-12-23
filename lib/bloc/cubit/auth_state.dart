part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class LoadingAuthState extends AuthState {}

class IsSignInState extends AuthState {}

class ErrorSignInState extends AuthState {}

class InternetConnectState extends AuthState {}

class InternetDesconnectState extends AuthState {}

class SignOutState extends AuthState {}
