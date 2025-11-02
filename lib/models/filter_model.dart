import '../models/pagination_model.dart';

import 'dashBoard_response.dart';

class FilterResponse {
  Pagination? pagination;
  List<Property>? property;

  FilterResponse({this.pagination, this.property});

  FilterResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['property'] != null) {
      property = <Property>[];
      json['property'].forEach((v) {
        property!.add(Property.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (property != null) {
      data['property'] = property!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

