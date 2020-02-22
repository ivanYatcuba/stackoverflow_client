import 'package:equatable/equatable.dart';
import 'package:flutter_stackoverflow/bloc/base/error_state.dart';
import 'package:flutter_stackoverflow/bloc/base/list_initial_state.dart';
import 'package:flutter_stackoverflow/bloc/base/page_state.dart';
import 'package:flutter_stackoverflow/model/tag/tag.dart';

abstract class TagListState extends Equatable {
  const TagListState();

  @override
  List<Object> get props => [];
}

class InitialTagListState extends TagListState implements BaseListInitialState {
}

class TagListError extends TagListState implements BaseListError<Tag> {
  final String errorMessage;
  final TagListLoaded listState;

  TagListError(this.errorMessage, this.listState);

  @override
  List<Object> get props => [this.errorMessage, this.listState];
}

class TagListLoaded extends TagListState implements BasePageState<Tag> {
  final List<Tag> data;
  final bool hasReachedMax;

  const TagListLoaded({
    this.data,
    this.hasReachedMax,
  });

  TagListLoaded copyWith({
    List<Tag> data,
    bool hasReachedMax,
  }) {
    return TagListLoaded(
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [this.data, this.hasReachedMax];
}
