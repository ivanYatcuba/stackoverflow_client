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
        if (currentState is InitialTagListState) {
          final newState = await _loadFirstPage();
          yield newState;
          return;
        }
        if (currentState is TagListLoaded) {
          final newState = await _loadTagPage(currentState);
          yield newState;
          return;
        }
        if (currentState is TagListError) {
          if (currentState.tagsListState != null) {
            final newState = await _loadTagPage(currentState.tagsListState);
            yield newState;
          } else {
            final newState = await _loadFirstPage();
            yield newState;
          }
        }
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        if (currentState is TagListLoaded) {
          yield TagListError(e.toString(), currentState);
          return;
        }
        if (currentState is TagListError) {
          yield currentState;
          return;
        } else {
          yield TagListError(e.toString(), null);
        }
      }
    }
  }

  Future<TagListState> _loadTagPage(TagListLoaded tagListState) async {
    final int page =
        (tagListState.tags.length / _tagRepository.pageSize).floor() + 1;
    final tagsList = await _tagRepository.fetchTags(page);
    return tagListState.hasReachedMax
        ? tagListState.copyWith(hasReachedMax: true)
        : TagListLoaded(
            tags: tagListState.tags + tagsList.items,
            hasReachedMax: tagsList.hasReachedMax,
          );
  }

  Future<TagListLoaded> _loadFirstPage() async {
    final tagList = await _tagRepository.fetchTags(1);
    return TagListLoaded(
        tags: tagList.items, hasReachedMax: tagList.hasReachedMax);
  }

  bool _hasReachedMax(TagListState state) =>
      state is TagListLoaded && state.hasReachedMax;
}
