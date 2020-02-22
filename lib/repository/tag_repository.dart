import 'package:dio/dio.dart';
import 'package:flutter_stackoverflow/model/tag/tag_list.dart';
import 'package:flutter_stackoverflow/model/tag/tag_wiki.dart';
import 'package:flutter_stackoverflow/model/tag/tag_wiki_list.dart';

class TagRepository {
  final int pageSize = 20;
  final String site = "stackoverflow";
  final String order = "desc";

  final Dio _dio;

  TagRepository(this._dio);

  Future<TagList> fetchTags(int page) async {
    final Response tagListResponse = await _dio.get(
      "/tags",
      queryParameters: {
        'page': page,
        'pagesize': pageSize,
        'site': site,
        'order': order,
      },
    );
    final tagList = TagList.fromJson(tagListResponse.data);
    if (tagList.items.isNotEmpty) {
      final tagWikiList = await getTagWikiList(tagList);
      if (tagWikiList.items.isNotEmpty) {
        tagList.items.forEach((it) {
          TagWiki tagWiki = tagWikiList.items.firstWhere(
              (element) => element.tagName == it.name,
              orElse: null);
          if (tagWiki != null) {
            it.description = tagWiki.excerpt;
          }
        });
      }
    }
    return tagList;
  }

  Future<TagWikiList> getTagWikiList(TagList tagList) async {
    final tagsQuery = tagList.items.map((it) => it.name).join(";");
    final encodedTags =  Uri.encodeComponent(tagsQuery);
    Response tagWikiResponse = await _dio.get(
      "/tags/$encodedTags/wikis",
      queryParameters: {
        'page': 1,
        'pagesize': pageSize,
        'site': site,
      },
    );
    return TagWikiList.fromJson(tagWikiResponse.data);
  }
}
