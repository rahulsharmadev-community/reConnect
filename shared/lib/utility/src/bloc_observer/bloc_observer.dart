import 'package:bloc/bloc.dart';
import 'package:logs/logs.dart';

class FlutterBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    bloc.state;
    _printLogs('onCreate', bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _printLogs('onClose', bloc);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    _printLogs('onEvent', bloc);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _printLogs('onChange', bloc, change.nextState);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    _printLogs('onTransition', bloc, transition.nextState);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }

  _printLogs(String action, dynamic bloc, [dynamic nextState]) {
    var str = {
      'BLOC': '${bloc.runtimeType}',
      'ACTION': action,
      'CURRENT STATE': '${bloc.state.runtimeType}',
      'NEXT STATE': '${nextState.runtimeType}'
    };
    logs.verbose(str);
  }
}
