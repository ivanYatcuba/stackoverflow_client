import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stackoverflow/bloc/tag_list/bloc.dart';
import 'package:flutter_stackoverflow/generated/i18n.dart';
import 'package:flutter_stackoverflow/screen/tag/tag_widget.dart';
import 'package:flutter_stackoverflow/widget/bottom_loader.dart';
import 'package:flutter_stackoverflow/widget/refresh_view.dart';

class TagListScreen extends StatefulWidget {
  @override
  _TagListScreenState createState() => _TagListScreenState();
}

class _TagListScreenState extends State<TagListScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  TagListBloc _tagListBloc;
  bool loadingNextPage = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tagListBloc = BlocProvider.of<TagListBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagListBloc, TagListState>(
      builder: (context, state) {
        if (loadingNextPage) {
          loadingNextPage = false;
        }
        if (state is TagListError) {
          final currentState = state as TagListError;
          if (currentState.tagsListState == null) {
            return _messageWidget(currentState.errorMessage);
          } else {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(currentState.errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    ));
            state = currentState.tagsListState;
          }
        }
        if (state is TagListLoaded) {
          final currentState = state;
          if (state.tags.isEmpty) {
            return _messageWidget(S.of(context).label_no_tags_loaded);
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= currentState.tags.length
                  ? BottomLoader()
                  : TagWidget(tag: currentState.tags[index]);
            },
            itemCount:
                state.hasReachedMax ? state.tags.length : state.tags.length + 1,
            controller: _scrollController,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _messageWidget(String message) {
    return RefreshView(
      message: message,
      refreshKey: _refreshKey,
      refreshCallback: _refreshList,
    );
  }

  Future<void> _refreshList() async {
    _refreshKey.currentState?.show();
    _tagListBloc.add(FetchTags());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (!loadingNextPage) {
        loadingNextPage = true;
        _tagListBloc.add(FetchTags());
      }
    }
  }
}
