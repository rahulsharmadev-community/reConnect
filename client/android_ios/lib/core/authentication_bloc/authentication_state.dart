part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class Authorized extends AuthenticationState {
  final LogInUser logInUser;

  Authorized(this.logInUser);
}

class Unauthorized extends AuthenticationState {
  final String message;
  Unauthorized(
      {this.message = 'Unauthorized user, Try again with vaild information.'});
}

class AuthenticatingState extends AuthenticationState {}

class ErrorState extends AuthenticationState {
  final String errorMessage;
  ErrorState(this.errorMessage);
}
