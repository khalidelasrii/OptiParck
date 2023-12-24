part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class LoadingAuthState extends AuthState {}

class IsSignInState extends AuthState {
  final Client user;

  const IsSignInState({required this.user});
  @override
  List<Object> get props => [user];
}

class ErrorSignInState extends AuthState {}

class InternetConnectState extends AuthState {}

class InternetDesconnectState extends AuthState {}

class SignOutState extends AuthState {}

class IsSignUpState extends AuthState {}
