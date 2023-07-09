import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/core/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final DeviceInfo deviceInfo;
  final PrimaryUserRepository userRepository;
  final PrimaryUserBloc primaryUserBloc;
  AuthenticationBloc(
      {required this.deviceInfo,
      required this.userRepository,
      required this.primaryUserBloc})
      : super(AuthenticatingState()) {
    on<CheckDeviceRegistered>(onCheckDeviceRegistered);
    on<DeviceRegistration>(onDeviceRegistration);
  }

  FutureOr<void> onCheckDeviceRegistered(
      CheckDeviceRegistered event, Emitter<AuthenticationState> emit) async {
    final primaryUser = await userRepository.fetchPrimaryUser();

    primaryUser != null
        ? {
            emit(Authorized(primaryUser)),
            primaryUserBloc.add(PrimaryUserIntial(primaryUser))
          }
        : {emit(Unauthorized()), primaryUserBloc.add(PrimaryUserDispose())};
  }

  FutureOr<void> onDeviceRegistration(
      DeviceRegistration event, Emitter<AuthenticationState> emit) async {
    var newUser = PrimaryUser(
      deviceInfo: deviceInfo,
      name: event.name,
      email: event.email,
      phoneNumber: event.phoneNumber,
    );
    await userRepository.CreatePrimaryUserAccount(newUser);
    emit(Authorized(newUser));
    primaryUserBloc.add(PrimaryUserIntial(newUser));
  }
}
