import 'package:dio/dio.dart';
import 'package:flutter_stackoverflow/model/question/question_list.dart';

class QuestionRepository {
  final int pageSize = 20;
  final String site = "stackoverflow";
  final String order = "desc";

  final Dio _dio;

  QuestionRepository(this._dio);

  Future<QuestionList> questionList(int page, String tagged) async {
    final Response questionListResponse = await _dio.get(
      "/questions",
      queryParameters: {
        'page': page,
        'pagesize': pageSize,
        'site': site,
        'order': order,
        'tagged': tagged,
        'filter': '!9Z(-wwYGT'
      },
    );
    return QuestionList.fromJson(questionListResponse.data);
  }
}