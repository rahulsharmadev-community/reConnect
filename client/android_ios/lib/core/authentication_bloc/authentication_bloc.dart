import 'dart:async';
import 'package:android_info/android_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/firebase_bloc/login_user_bloc/login_user_bloc.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/models/_models.dart';
import 'package:shared/shared.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final DeviceInfo deviceInfo;
  final UserRepository userRepository;
  final LoginUserBloc loginUserBloc;
  AuthenticationBloc(
      {required this.deviceInfo,
      required this.userRepository,
      required this.loginUserBloc})
      : super(AuthenticatingState()) {
    on<CheckDeviceRegistered>(onCheckDeviceRegistered);
    on<DeviceRegistration>(onDeviceRegistration);
  }

  FutureOr<void> onCheckDeviceRegistered(
      CheckDeviceRegistered event, Emitter<AuthenticationState> emit) async {
    logs(deviceInfo.toJson);
    final logInUser = await userRepository.fetchLoginUserByDevice(deviceInfo);

    logInUser != null
        ? {
            emit(Authorized(logInUser)),
            loginUserBloc.add(LoginUserIntial(logInUser))
          }
        : {emit(Unauthorized()), loginUserBloc.add(LoginUserDispose())};
  }

  FutureOr<void> onDeviceRegistration(
      DeviceRegistration event, Emitter<AuthenticationState> emit) async {
    var newUser = LogInUser(
      deviceInfo: deviceInfo,
      name: event.name,
      email: event.email,
      phoneNumber: event.phoneNumber,
    );
    await userRepository.CreateLogInUserAccount(newUser);
    emit(Authorized(newUser));
  }
}