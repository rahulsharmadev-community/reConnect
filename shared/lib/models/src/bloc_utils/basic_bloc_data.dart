import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum BlocDataState {
  idle,
  processing,
  finished,
  error,
}
@immutable
class BlocData<A> extends Equatable {
  final A? data;
  final BlocDataState state;
  final String? errorMsg;

  bool get hasData => data != null;
  bool get hasError => state == BlocDataState.error;

  const BlocData._internal(this.data, this.state, this.errorMsg);

  const BlocData.processing()
      : state = BlocDataState.processing,
        data = null,
        errorMsg = null;

  /// idle: The initial state before any update operation is triggered.
  /// As a result, data may or may not be available during an idle state.
  const BlocData.idle([A? data])
      : state = BlocDataState.idle,
        data = data,
        errorMsg = null;

  const BlocData.error(this.errorMsg)
      : state = BlocDataState.error,
        data = null;

  const BlocData.finished(this.data)
      : state = BlocDataState.finished,
        errorMsg = null;

  static BlocData<A> fromMap<A>(Map<String, dynamic> json) =>
      BlocData._internal(
        json['data'],
        json['state'],
        json['errorMsg'],
      );

  Map<String, dynamic> get toMap => {
        'data': data,
        'state': state.index,
        'errorMsg': errorMsg,
      };

  @override
  List<Object?> get props => [state, data, errorMsg];
}
