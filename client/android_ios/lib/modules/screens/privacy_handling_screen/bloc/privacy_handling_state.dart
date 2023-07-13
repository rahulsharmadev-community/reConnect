// ignore_for_file: camel_case_types

part of 'privacy_handling_bloc.dart';

@immutable
abstract class PrivacyHandlingState {}

class PrivacyHandlingLoading extends PrivacyHandlingState {}

class PrivacyHandlingEverybody extends PrivacyHandlingState {}

class PrivacyHandlingNobody extends PrivacyHandlingState {}

class PrivacyHandlingExcept extends PrivacyHandlingState {
  final List<String> contects;
  PrivacyHandlingExcept(this.contects);
}

class PrivacyHandlingOnly extends PrivacyHandlingState {
  final List<String> contects;
  PrivacyHandlingOnly(this.contects);
}
