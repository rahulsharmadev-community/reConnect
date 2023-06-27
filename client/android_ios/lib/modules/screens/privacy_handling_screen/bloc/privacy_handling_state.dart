// ignore_for_file: camel_case_types

part of 'privacy_handling_bloc.dart';

@immutable
abstract class PrivacyHandlingState {}

class PHS_Loading extends PrivacyHandlingState {}

class PHS_Everybody extends PrivacyHandlingState {}

class PHS_Nobody extends PrivacyHandlingState {}

class PHS_Except extends PrivacyHandlingState {
  final List<String> contects;
  PHS_Except(this.contects);
}

class PHS_Only extends PrivacyHandlingState {
  final List<String> contects;
  PHS_Only(this.contects);
}
