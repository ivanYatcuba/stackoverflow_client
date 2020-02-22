import 'package:equatable/equatable.dart';
import 'package:flutter_stackoverflow/bloc/base/error_state.dart';
import 'package:flutter_stackoverflow/bloc/base/list_initial_state.dart';
import 'package:flutter_stackoverflow/bloc/base/page_state.dart';
import 'package:flutter_stackoverflow/model/question/question.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();
}

class InitialQuestionState extends QuestionState
    implements BaseListInitialState {
  @override
  List<Object> get props => [];
}

class QuestionListError extends QuestionState
    implements BaseListError<Question> {
  final String errorMessage;
  final QuestionListLoaded listState;

  QuestionListError(this.errorMessage, this.listState);

  @override
  List<Object> get props => [this.errorMessage, this.listState];
}

class QuestionListLoaded extends QuestionState
    implements BasePageState<Question> {
  final List<Question> data;
  final bool hasReachedMax;

  const QuestionListLoaded({
    this.data,
    this.hasReachedMax,
  });

  QuestionListLoaded copyWith({
    List<Question> data,
    bool hasReachedMax,
  }) {
    return QuestionListLoaded(
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [this.data, this.hasReachedMax];
}
