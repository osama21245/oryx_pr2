import 'pagination_model.dart';

class CategoryListModel {
  Pagination? pagination;
  List<CategoryData>? data;

  CategoryListModel({this.pagination, this.data});

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(CategoryData.fromJson(v));
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

class CategoryData {
  int? id;
  String? name;
  int? status;
  String? categoryImage;
  List<AmenityName>? amenityName;
  String? createdAt;
  String? updatedAt;

  CategoryData(
      {this.id,
      this.name,
      this.status,
      this.categoryImage,
      this.amenityName,
      this.createdAt,
      this.updatedAt});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    categoryImage = json['category_image'];
    if (json['amenity_name'] != null) {
      amenityName = <AmenityName>[];
      json['amenity_name'].forEach((v) {
        amenityName!.add(AmenityName.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['category_image'] = categoryImage;
    if (amenityName != null) {
      data['amenity_name'] = amenityName!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class AmenityName {
  int? id;
  int? propertyId;
  int? amenityId;
  String? name;
  int? status;
  String? type;
  dynamic value;
  String? createdAt;
  String? updatedAt;
  String? amenityImage;
  bool? isExpansionExpanded;

  AmenityName(
      {this.id,
      this.name,
      this.status,
      this.type,
      this.value,
      this.createdAt,
      this.updatedAt,
      this.amenityId,
      this.propertyId,
      this.isExpansionExpanded = false});

  AmenityName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amenityId = json['amenity_id'];
    propertyId = json["property_id"];
    name = json['name'];
    status = json['status'];
    type = json['type'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    amenityImage = json['amenity_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['property_id'] = propertyId;
    data['amenity_id'] = amenityId;
    data['name'] = name;
    data['status'] = status;
    data['type'] = type;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['amenity_image'] = amenityImage;
    return data;
  }
}
