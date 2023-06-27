// ignore_for_file: camel_case_types

part of 'primary_user_bloc.dart';

@immutable
class PrimaryUserState {
  static PrimaryUserState fromJson(Map<String, dynamic> map) {
    switch (map['state']) {
      case PrimaryUserLoading:
        return PrimaryUserLoading();
      case PrimaryUserError:
        return PrimaryUserError(map['errorMessage']);
      default:
        return PrimaryUserLoaded.fromJson(map);
    }
  }

  Map<String, dynamic> get toJson => {};
}

class PrimaryUserError extends PrimaryUserState {
  final String errorMessage;
  PrimaryUserError(this.errorMessage);
}

class PrimaryUserLoading extends PrimaryUserState {}

class PrimaryUserLoaded extends PrimaryUserState {
  final PrimaryUser primaryUser;
  PrimaryUserLoaded(this.primaryUser);

  static PrimaryUserLoaded fromJson(Map<String, dynamic> map) =>
      PrimaryUserLoaded.fromJson(map);

  @override
  Map<String, dynamic> get toJson => primaryUser.toMap;
}
