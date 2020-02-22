import 'package:flutter/material.dart';
import 'package:flutter_stackoverflow/bloc/question/bloc.dart';
import 'package:flutter_stackoverflow/generated/i18n.dart';
import 'package:flutter_stackoverflow/model/question/question.dart';
import 'package:flutter_stackoverflow/screen/base/base_list_screen.dart';
import 'package:flutter_stackoverflow/screen/question/question_widget.dart';

class QuestionsScreen extends BaseInfiniteList {
  final String tag;

  QuestionsScreen({Key key, this.tag}) : super();

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends BaseInfiniteListState<Question,
    QuestionBloc, QuestionEvent, QuestionState> {
  @override
  String emptyPlaceholder() {
    return S.of(context).label_no_questions_loaded;
  }

  @override
  QuestionEvent getFetchEvent() {
    return FetchQuestions();
  }

  @override
  Widget getListWidget(Question data) {
    return QuestionWidget(question: data);
  }
}
