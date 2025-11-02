import 'pagination_model.dart';

class PropertyTypeResponse {
  bool? status;
  Pagination? pagination;
  List<PropertyTypeModel>? data;

  PropertyTypeResponse({this.status, this.pagination, this.data});

  PropertyTypeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <PropertyTypeModel>[];
      json['data'].forEach((v) {
        data!.add(PropertyTypeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyTypeModel {
  int? id;
  String? name;
  int? status;
  String? propertyTypeImage;
  String? createdAt;
  String? updatedAt;
  bool? select;

  PropertyTypeModel({
    this.id,
    this.name,
    this.status,
    this.propertyTypeImage,
    this.createdAt,
    this.updatedAt,
    this.select,
  });

  PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    propertyTypeImage = json['property_type_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // select = json['select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['property_type_image'] = propertyTypeImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
