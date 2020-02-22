import 'package:equatable/equatable.dart';
import 'package:flutter_stackoverflow/bloc/base/fetch_event.dart';

abstract class TagListEvent extends Equatable {
  const TagListEvent() : super();

  @override
  List<Object> get props => [];
}

class FetchTags extends TagListEvent implements BaseFetchEvent {}
