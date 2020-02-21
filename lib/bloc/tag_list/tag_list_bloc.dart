import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stackoverflow/repository/tag_repository.dart';

import 'bloc.dart';

class TagListBloc extends Bloc<TagListEvent, TagListState> {
  TagRepository _tagRepository;

  TagListBloc(this._tagRepository);

  @override
  TagListState get initialState => InitialTagListState();

  @override
  Stream<TagListState> mapEventToState(
    TagListEvent event,
  ) async* {
    final currentState = state;
    if (event is FetchTags && !_hasReachedMax(currentState)) {
      try {
        if (currentState is InitialTagListState || currentState is TagListError) {
          final tagList = await _tagRepository.fetchTags(1);
          yield TagListLoaded(
              tags: tagList.items, hasReachedMax: tagList.hasReachedMax);
          return;
        }
        if (currentState is TagListLoaded) {
          final int page =
              (currentState.tags.length / _tagRepository.pageSize).floor() + 1;
          final tagsList = await _tagRepository.fetchTags(page);
          yield tagsList.hasReachedMax
              ? currentState.copyWith(hasReachedMax: true)
              : TagListLoaded(
                  tags: currentState.tags + tagsList.items,
                  hasReachedMax: tagsList.hasReachedMax,
                );
        }
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        yield TagListError(e.toString());
      }
    }
  }

  bool _hasReachedMax(TagListState state) =>
      state is TagListLoaded && state.hasReachedMax;
}
