// ignore_for_file: camel_case_types

part of 'login_user_bloc_bloc.dart';

@immutable
abstract class LoginUserState {
  static LoginUserState fromJson(Map<String, dynamic> map) {
    switch (map['state']) {
      case LoginUserLoading:
        return LoginUserLoading();
      case LoginUserError:
        return LoginUserError(map['errorMessage']);
      default:
        return LoginUserLoaded.fromJson(map);
    }
  }

  get toJson => {};
}

class LoginUserError extends LoginUserState {
  final String errorMessage;
  LoginUserError(this.errorMessage);
}

class LoginUserLoading extends LoginUserState {}

class LoginUserLoaded extends LoginUserState {
  final LogInUser logInUser;
  LoginUserLoaded(this.logInUser);

  static LoginUserLoaded fromJson(Map<String, dynamic> map) =>
      LoginUserLoaded.fromJson(map);

  @override
  get toJson => logInUser.toMap;
}
