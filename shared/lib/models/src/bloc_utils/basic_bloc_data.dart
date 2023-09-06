import 'package:meta/meta.dart';

enum BlocDataState {
  idle,
  processing,
  finished,
  error,
}

@immutable
class BlocData<A> {
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

  factory BlocData.fromMap(Map<String, dynamic> json) => BlocData._internal(
        json['data'],
        BlocDataState.values.byName(json['state']),
        json['errorMsg'],
      );

  Map<String, dynamic> get toMap => {
        'data': data,
        'state': state.name,
        'errorMsg': errorMsg,
      };

  @override
  int get hashCode => data.hashCode ^ state.index.hashCode ^ errorMsg.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlocData &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          state.index == other.state.index &&
          errorMsg == other.errorMsg;
}
