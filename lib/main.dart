import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stackoverflow/generated/i18n.dart';
import 'package:flutter_stackoverflow/repository/tag_repository.dart';
import 'package:flutter_stackoverflow/screen/tag/tag_list_screen.dart';

import 'bloc/tag_list/bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Stack overflow sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    BaseOptions options = new BaseOptions(
      baseUrl: "https://api.stackexchange.com/2.2",
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    dio.interceptors.add(LogInterceptor(responseBody: true));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<TagRepository>(
            create: (context) => TagRepository(dio),
          ),
        ],
        child: BlocProvider(
          create: (context) =>
              TagListBloc(RepositoryProvider.of<TagRepository>(context))
                ..add(FetchTags()),
          child: SafeArea(child: TagListScreen()),
        ),
      ),
    );
  }
}
