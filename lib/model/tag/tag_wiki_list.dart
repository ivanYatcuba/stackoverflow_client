import 'package:flutter_stackoverflow/model/tag/tag_wiki.dart';

class TagWikiList {
  List<TagWiki> items;
  bool hasMore;
  int quotaMax;
  int quotaRemaining;

  TagWikiList({this.items, this.hasMore, this.quotaMax, this.quotaRemaining});

  TagWikiList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<TagWiki>();
      json['items'].forEach((v) {
        items.add(new TagWiki.fromJson(v));
      });
    }
    hasMore = json['has_more'];
    quotaMax = json['quota_max'];
    quotaRemaining = json['quota_remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['has_more'] = this.hasMore;
    data['quota_max'] = this.quotaMax;
    data['quota_remaining'] = this.quotaRemaining;
    return data;
  }
}
