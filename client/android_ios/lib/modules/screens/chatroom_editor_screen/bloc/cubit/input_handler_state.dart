part of 'input_handler_cubit.dart';

@immutable
class InputHandlerCubitState {
  final List<String> administrators;
  final List<String> members;
  final List<String> moderators;
  final List<String> visitors;

  const InputHandlerCubitState({
    this.administrators = const [],
    this.members = const [],
    this.moderators = const [],
    this.visitors = const [],
  });

  InputHandlerCubitState copyWith(
    List<String>? administrators,
    List<String>? members,
    List<String>? moderators,
    List<String>? visitors,
  ) =>
      InputHandlerCubitState(
        administrators: administrators ?? this.administrators,
        members: members ?? this.members,
        moderators: moderators ?? this.moderators,
        visitors: visitors ?? this.visitors,
      );
}
