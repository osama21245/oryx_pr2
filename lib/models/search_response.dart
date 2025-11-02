class SearchModel {
  int? id;
  String? title;

  SearchModel({
    this.id,
    this.title,
  });

  SearchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['duration'] = title;

    return data;
  }
}
