part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class CheckDeviceRegistered extends AuthenticationEvent {}

class DeviceRegistration extends AuthenticationEvent {
  final String name;
  final String? email, phoneNumber;
  DeviceRegistration({required this.name, this.email, this.phoneNumber});
}
