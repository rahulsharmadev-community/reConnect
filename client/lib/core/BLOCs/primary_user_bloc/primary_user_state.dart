// ignore_for_file: camel_case_types

part of 'primary_user_bloc.dart';

@immutable
abstract class PrimaryUserState {
  static PrimaryUserState fromMap(Map<String, dynamic> map) {
    PrimaryUserState state = map['state'];
    if (state is PrimaryUserLoading) {
      return PrimaryUserLoading();
    } else if (state is PrimaryUserError) {
      return PrimaryUserError.fromMap(state.toMap);
    } else {
      return PrimaryUserLoaded.fromMap(state.toMap);
    }
  }

  Map<String, dynamic> get toMap => {'state': this};
}

class PrimaryUserError extends PrimaryUserState {
  final String errorMsg;
  PrimaryUserError(this.errorMsg);

  static PrimaryUserError fromMap(Map<String, dynamic> json) =>
      PrimaryUserError(json['errorMsg']);

  @override
  Map<String, dynamic> get toMap => {'errorMsg': errorMsg};
}

class PrimaryUserLoading extends PrimaryUserState {}

class PrimaryUserLoaded extends PrimaryUserState {
  final PrimaryUser primaryUser;
  final String? errorMsg;
  PrimaryUserLoaded(this.primaryUser, [this.errorMsg]);

  static PrimaryUserLoaded fromMap(Map<String, dynamic> json) =>
      PrimaryUserLoaded(json['errorMsg'], json['primaryUser']);

  @override
  Map<String, dynamic> get toMap =>
      {'errorMsg': errorMsg, 'primaryUser': primaryUser.toMap};
}
