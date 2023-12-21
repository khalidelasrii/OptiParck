part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class LodingAuthState extends AuthState{}
class IsSingInState extends AuthState{}
class ErrorSingState extends AuthState{}


 
