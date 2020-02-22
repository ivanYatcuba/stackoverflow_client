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
  final TagListLoaded tagsListState;

  TagListError(this.errorMessage, this.tagsListState);

  @override
  List<Object> get props => [this.errorMessage, this.tagsListState];
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
  List<Object> get props => [this.tags, this.hasReachedMax];
}
