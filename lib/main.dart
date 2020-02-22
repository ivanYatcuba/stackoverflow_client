import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stackoverflow/bloc/question/question_bloc.dart';
import 'package:flutter_stackoverflow/bloc/question/question_event.dart';
import 'package:flutter_stackoverflow/generated/i18n.dart';
import 'package:flutter_stackoverflow/repository/question_repository.dart';
import 'package:flutter_stackoverflow/repository/tag_repository.dart';
import 'package:flutter_stackoverflow/screen/question/question_screen.dart';
import 'package:flutter_stackoverflow/screen/tag/tag_list_screen.dart';

import 'bloc/tag_list/bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseOptions options = new BaseOptions(
      baseUrl: "https://api.stackexchange.com/2.2",
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    dio.interceptors.add(LogInterceptor(responseBody: true));

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
      onGenerateRoute: (settings) {
        final arguments = settings.arguments as List;
        Widget screen;
        switch (settings.name) {
          case '/':
            screen = Scaffold(
              appBar: AppBar(
                title: Text('Stack overflow sample'),
              ),
              body: BlocProvider(
                create: (context) => TagListBloc(
                  TagRepository(dio),
                )..add(FetchTags()),
                child: SafeArea(child: TagListScreen()),
              ),
            );
            break;
          case '/question':
            final String tag = arguments[0];
            screen = BlocProvider(
              create: (context) => QuestionBloc(
                QuestionRepository(dio),
                tag,
              )..add(FetchQuestions()),
              child: Scaffold(
                appBar: AppBar(
                  title: Text(tag),
                ),
                body: SafeArea(child: QuestionsScreen(tag: tag)),
              ),
            );
            break;
        }
        return MaterialPageRoute(
          builder: (context) {
            return screen;
          },
        );
      },
    );
  }
}
