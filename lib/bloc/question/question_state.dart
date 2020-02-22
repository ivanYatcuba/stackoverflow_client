import 'package:equatable/equatable.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();
}

class InitialQuestionState extends QuestionState {
  @override
  List<Object> get props => [];
}
