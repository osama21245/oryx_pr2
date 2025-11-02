import 'pagination_model.dart';

class LimitPropertyResponse {
  Pagination? pagination;
  List<LimitPropertyModel>? data;

  LimitPropertyResponse({this.pagination, this.data});

  LimitPropertyResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <LimitPropertyModel>[];
      json['data'].forEach((v) {
        data!.add(LimitPropertyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



class LimitPropertyModel {
  int? id;
  int? limit;
  int? price;
  String? priceFormat;
  String? type;
  String? createdAt;
  String? updatedAt;
  bool? select=false;

  LimitPropertyModel(
      {this.id,
        this.limit,
        this.price,
        this.priceFormat,
        this.type,
        this.createdAt,
        this.updatedAt,this.select});

  LimitPropertyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    limit = json['limit'];
    price = json['price'];
    priceFormat = json['price_format'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['limit'] = limit;
    data['price'] = price;
    data['price_format'] = priceFormat;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
