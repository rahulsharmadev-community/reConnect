part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class Authorized extends AuthenticationState {
  final PrimaryUser primaryUser;
  Authorized(this.primaryUser);
}

class Unauthorized extends AuthenticationState {
  final String msg;

  Unauthorized(
      {this.msg = 'Unauthorized user, Try again with vaild information.'});
}

class AuthenticatingState extends AuthenticationState {}

class ErrorState extends AuthenticationState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}
