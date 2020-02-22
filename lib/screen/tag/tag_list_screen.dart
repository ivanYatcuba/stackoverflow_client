import 'package:flutter/material.dart';
import 'package:flutter_stackoverflow/bloc/tag_list/bloc.dart';
import 'package:flutter_stackoverflow/generated/i18n.dart';
import 'package:flutter_stackoverflow/model/tag/tag.dart';
import 'package:flutter_stackoverflow/screen/base/base_list_screen.dart';
import 'package:flutter_stackoverflow/screen/tag/tag_widget.dart';

class TagListScreen extends BaseInfiniteList {
  @override
  _TagListScreenState createState() => _TagListScreenState();
}

class _TagListScreenState extends BaseInfiniteListState<Tag,
    TagListBloc, TagListEvent, TagListState> {

  @override
  String emptyPlaceholder() {
    return S.of(context).label_no_tags_loaded;
  }

  @override
  TagListEvent getFetchEvent() {
    return FetchTags();
  }

  @override
  Widget getListWidget(Tag data) {
    return TagWidget(tag: data);
  }
}
