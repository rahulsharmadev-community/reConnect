import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

typedef InnerRoutes = Map<Key, Widget>;

class InnerRouting extends Cubit<InnerRoutes> {
  InnerRouting() : super({});

  void push(Widget child) => emit({...state, UniqueKey(): child});

  void pop() {
    final list = state.entries.toList();
    list.removeLast();
    emit(Map.fromEntries(list));
  }

  void clearAll() => emit({});
}
