part of 'privacy_handling_bloc.dart';

@immutable
abstract class PrivacyHandlingEvent {}

class SetPrivacyState extends PrivacyHandlingEvent {
  final Privacy privacy;
  SetPrivacyState(this.privacy);
}
