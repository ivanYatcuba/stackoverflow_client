class Tag {
  bool hasSynonyms;
  bool isModeratorOnly;
  bool isRequired;
  int count;
  String name;
  String description;

  Tag(
      {this.hasSynonyms,
      this.isModeratorOnly,
      this.isRequired,
      this.count,
      this.name});

  Tag.fromJson(Map<String, dynamic> json) {
    hasSynonyms = json['has_synonyms'];
    isModeratorOnly = json['is_moderator_only'];
    isRequired = json['is_required'];
    count = json['count'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['has_synonyms'] = this.hasSynonyms;
    data['is_moderator_only'] = this.isModeratorOnly;
    data['is_required'] = this.isRequired;
    data['count'] = this.count;
    data['name'] = this.name;
    return data;
  }
}
