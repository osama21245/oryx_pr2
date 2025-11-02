class ViewPropertyResponse {
  Data? data;

  ViewPropertyResponse({this.data});

  ViewPropertyResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? totalView;
  String? status;

  Data({this.totalView, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    totalView = json['total_view'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_view'] = totalView;
    data['status'] = status;
    return data;
  }
}
