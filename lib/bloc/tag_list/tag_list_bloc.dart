import 'dart:async';

import 'package:flutter_stackoverflow/bloc/base/base_list_bloc.dart';
import 'package:flutter_stackoverflow/bloc/base/page_state.dart';
import 'package:flutter_stackoverflow/model/tag/tag.dart';
import 'package:flutter_stackoverflow/repository/tag_repository.dart';

import 'bloc.dart';

class TagListBloc extends BaseListBloc<Tag, TagListEvent, TagListState> {
  TagRepository _tagRepository;

  TagListBloc(this._tagRepository);

  @override
  TagListState get initialState => InitialTagListState();

  @override
  Future<TagListState> loadPage(BasePageState<Tag> tagListState) async {
    final int page =
        (tagListState.data.length / _tagRepository.pageSize).floor() + 1;
    final tagsList = await _tagRepository.fetchTags(page);
    return tagListState.hasReachedMax
        ? tagListState.copyWith(hasReachedMax: true) as TagListState
        : TagListLoaded(
            data: tagListState.data + tagsList.items,
            hasReachedMax: tagsList.hasReachedMax,
          );
  }

  Future<TagListLoaded> loadFirstPage() async {
    final tagList = await _tagRepository.fetchTags(1);
    return TagListLoaded(
      data: tagList.items,
      hasReachedMax: tagList.hasReachedMax,
    );
  }

  @override
  TagListState buildErrorState(String error, BasePageState pageState) {
    return TagListError(error, pageState);
  }
}
