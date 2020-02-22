import 'package:flutter/material.dart';

class RefreshView extends StatelessWidget {
  final String message;
  final GlobalKey<RefreshIndicatorState> refreshKey;
  final RefreshCallback refreshCallback;

  const RefreshView({
    Key key,
    this.message,
    this.refreshKey,
    this.refreshCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      child: Stack(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(this.message),
            ),
          ),
          ListView()
        ],
      ),
      onRefresh: this.refreshCallback,
    );
  }
}
