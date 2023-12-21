part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class LoadingAuthState extends AuthState {}

class IsSignInState extends AuthState {}

class ErrorSignInState extends AuthState {}
