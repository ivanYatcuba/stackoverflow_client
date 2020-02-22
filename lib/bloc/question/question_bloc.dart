import 'dart:async';

import 'package:flutter_stackoverflow/bloc/base/base_list_bloc.dart';
import 'package:flutter_stackoverflow/bloc/base/page_state.dart';
import 'package:flutter_stackoverflow/model/question/question.dart';
import 'package:flutter_stackoverflow/repository/question_repository.dart';

import './bloc.dart';

class QuestionBloc extends BaseListBloc<Question, QuestionEvent, QuestionState> {
  final QuestionRepository _questionRepository;
  final String tag;

  QuestionBloc(this._questionRepository, this.tag);

  @override
  QuestionState get initialState => InitialQuestionState();

  @override
  QuestionState buildErrorState(String error, BasePageState pageState) {
    return QuestionListError(error, pageState);
  }

  @override
  Future<QuestionState> loadFirstPage() async {
    final questionsList = await _questionRepository.questionList(1, tag);
    return QuestionListLoaded(
      data: questionsList.items,
      hasReachedMax: questionsList.hasReachedMax,
    );
  }

  @override
  Future<QuestionState> loadPage(BasePageState pageState) async {
    final int page =
        (pageState.data.length / _questionRepository.pageSize).floor() + 1;
    final tagsList = await _questionRepository.questionList(page, tag);
    return pageState.hasReachedMax
        ? pageState.copyWith(hasReachedMax: true) as QuestionState
        : QuestionListLoaded(
      data: pageState.data + tagsList.items,
      hasReachedMax: tagsList.hasReachedMax,
    );
  }
}
