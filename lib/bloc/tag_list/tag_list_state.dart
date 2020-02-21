import 'package:equatable/equatable.dart';
import 'package:flutter_stackoverflow/model/tag/tag.dart';

abstract class TagListState extends Equatable {
  const TagListState();

  @override
  List<Object> get props => [];
}

class InitialTagListState extends TagListState {}

class TagListError extends TagListState {
  final String errorMessage;

  TagListError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class TagListLoaded extends TagListState {
  final List<Tag> tags;
  final bool hasReachedMax;

  const TagListLoaded({
    this.tags,
    this.hasReachedMax,
  });

  TagListLoaded copyWith({
    List<Tag> posts,
    bool hasReachedMax,
  }) {
    return TagListLoaded(
      tags: posts ?? this.tags,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [tags, hasReachedMax];
}
