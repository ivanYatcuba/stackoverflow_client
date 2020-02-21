import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stackoverflow/bloc/tag_list/bloc.dart';
import 'package:flutter_stackoverflow/model/tag/tag.dart';

class TagListScreen extends StatefulWidget {
  @override
  _TagListScreenState createState() => _TagListScreenState();
}

class _TagListScreenState extends State<TagListScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  TagListBloc _tagListBloc;

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
        if (state is TagListError) {
          return _messageWidget(state.errorMessage);
        }
        if (state is TagListLoaded) {
          if (state.tags.isEmpty) {
            return _messageWidget('No tags!');
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.tags.length
                  ? BottomLoader()
                  : TagWidget(tag: state.tags[index]);
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
    return RefreshIndicator(
      onRefresh: _refreshList,
      key: _refreshKey,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Center(
                child: Text(message),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _refreshList() async {
    _refreshKey.currentState?.show();
    _tagListBloc.add(FetchTags());
    return null;
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
      _tagListBloc.add(FetchTags());
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  final Tag tag;

  const TagWidget({Key key, @required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Container(child: Text(tag.name)),
                  Text(
                    tag.count.toString(),
                    style: TextStyle(fontSize: 10.0),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Text(tag.description ?? ""),
            ),
          ],
        ),
      ),
    );
  }
}
