import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stackoverflow/bloc/base/fetch_event.dart';
import 'package:flutter_stackoverflow/bloc/base/list_initial_state.dart';
import 'package:flutter_stackoverflow/bloc/base/page_state.dart';

import 'error_state.dart';

abstract class BaseListBloc<T, EVENT, STATE> extends Bloc<EVENT, STATE> {
  @override
  Stream<STATE> mapEventToState(EVENT event) async* {
    final currentState = state;
    if (event is BaseFetchEvent && !_hasReachedMax(currentState)) {
      try {
        if (currentState is BaseListInitialState) {
          final newState = await loadFirstPage();
          yield newState;
          return;
        }
        if (currentState is BasePageState<T>) {
          final newState = await loadPage(currentState);
          yield newState;
          return;
        }
        if (currentState is BaseListError<T>) {
          if (currentState.listState != null) {
            final newState = await loadPage(currentState.listState);
            yield newState;
          } else {
            final newState = await loadFirstPage();
            yield newState;
          }
        }
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        if (currentState is BasePageState<T>) {
          yield buildErrorState(e.toString(), currentState);
          return;
        }
        if (currentState is BaseListError<T>) {
          yield currentState;
          return;
        } else {
          yield buildErrorState(e.toString(), null);
        }
      }
    }
  }

  STATE buildErrorState(String error, BasePageState<T> pageState);

  Future<STATE> loadPage(BasePageState<T> pageState);

  Future<STATE> loadFirstPage();

  bool _hasReachedMax(STATE state) =>
      state is BasePageState<T> && state.hasReachedMax;
}
