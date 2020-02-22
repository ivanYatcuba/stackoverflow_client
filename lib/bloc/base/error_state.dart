import 'package:flutter_stackoverflow/bloc/base/page_state.dart';

abstract class BaseListError<T> {
  String get errorMessage;
  BasePageState<T> get listState;
}
