import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  @override
  QuestionState get initialState => InitialQuestionState();

  @override
  Stream<QuestionState> mapEventToState(
    QuestionEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
