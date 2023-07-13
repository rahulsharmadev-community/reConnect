part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {
  static CheckDeviceRegistered checkDeviceRegistered() =>
      CheckDeviceRegistered();
  static DeviceRegistration deviceRegistration(String name,
          [String? email, String? phoneNumber]) =>
      DeviceRegistration(name, email, phoneNumber);
}

class CheckDeviceRegistered extends AuthenticationEvent {}

class DeviceRegistration extends AuthenticationEvent {
  final String name;
  final String? email, phoneNumber;
  DeviceRegistration(this.name, [this.email, this.phoneNumber]);
}
