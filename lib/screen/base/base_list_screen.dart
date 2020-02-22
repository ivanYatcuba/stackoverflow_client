import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stackoverflow/bloc/base/error_state.dart';
import 'package:flutter_stackoverflow/bloc/base/page_state.dart';
import 'package:flutter_stackoverflow/widget/bottom_loader.dart';
import 'package:flutter_stackoverflow/widget/refresh_view.dart';

abstract class BaseInfiniteList extends StatefulWidget {}

abstract class BaseInfiniteListState<T, BLOC extends Bloc<EVENT, STATE>, EVENT,
    STATE> extends State<BaseInfiniteList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  BLOC _bloc;
  bool loadingNextPage = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _bloc = BlocProvider.of<BLOC>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BLOC, STATE>(
      builder: (context, state) {
        if (loadingNextPage) {
          loadingNextPage = false;
        }
        if (state is BaseListError<T>) {
          final currentState = state as BaseListError<T>;
          if (currentState.listState == null) {
            return _messageWidget(currentState.errorMessage);
          } else {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(currentState.errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    ));
            state = currentState.listState as STATE;
          }
        }
        if (state is BasePageState<T>) {
          final BasePageState<T> currentState = state;
          if (state.data.isEmpty) {
            return _messageWidget(emptyPlaceholder());
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= currentState.data.length
                  ? BottomLoader()
                  : getListWidget(currentState.data[index]);
            },
            itemCount:
                state.hasReachedMax ? state.data.length : state.data.length + 1,
            controller: _scrollController,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget getListWidget(T data);

  EVENT getFetchEvent();

  String emptyPlaceholder();

  Widget _messageWidget(String message) {
    return RefreshView(
      message: message,
      refreshKey: _refreshKey,
      refreshCallback: _refreshList,
    );
  }

  Future<void> _refreshList() async {
    _refreshKey.currentState?.show();
    _bloc.add(getFetchEvent());
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
        _bloc.add(getFetchEvent());
      }
    }
  }
}
