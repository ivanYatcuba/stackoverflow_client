class TagWiki {
  int excerptLastEditDate;
  int bodyLastEditDate;
  String excerpt;
  String tagName;

  TagWiki(
      {this.excerptLastEditDate,
        this.bodyLastEditDate,
        this.excerpt,
        this.tagName});

  TagWiki.fromJson(Map<String, dynamic> json) {
    excerptLastEditDate = json['excerpt_last_edit_date'];
    bodyLastEditDate = json['body_last_edit_date'];
    excerpt = json['excerpt'];
    tagName = json['tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['excerpt_last_edit_date'] = this.excerptLastEditDate;
    data['body_last_edit_date'] = this.bodyLastEditDate;
    data['excerpt'] = this.excerpt;
    data['tag_name'] = this.tagName;
    return data;
  }
}