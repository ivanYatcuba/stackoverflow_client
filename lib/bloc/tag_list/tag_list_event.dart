import 'package:equatable/equatable.dart';

abstract class TagListEvent extends Equatable {
  const TagListEvent(): super();

  @override
  List<Object> get props => [];
}

class FetchTags extends TagListEvent {}