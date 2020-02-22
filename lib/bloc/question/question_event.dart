import 'package:equatable/equatable.dart';
import 'package:flutter_stackoverflow/bloc/base/fetch_event.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object> get props => [];
}

class FetchQuestions extends QuestionEvent implements BaseFetchEvent {}
