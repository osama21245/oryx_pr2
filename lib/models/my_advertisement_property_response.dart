import 'pagination_model.dart';

class MyAdvertisementPropertyResponse {
  bool? status;
  Pagination? pagination;
  List<MyAdvertisementPropertyModel>? data;

  MyAdvertisementPropertyResponse({this.status, this.pagination, this.data});

  MyAdvertisementPropertyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <MyAdvertisementPropertyModel>[];
      json['data'].forEach((v) {
        data!.add(MyAdvertisementPropertyModel.fromJson(v));
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


class MyAdvertisementPropertyModel {
  int? id;
  String? name;
  int? categoryId;
  String? category;
  String? categoryImage;
  int? price;
  String? priceFormat;
  String? address;
  int? status;
  int? premiumProperty;
  String? propertyImage;
  int? isFavourite;
  int? propertyTypeId;
  String? propertyType;
  int? propertyFor;
  int? advertisementProperty;
  String? advertisementPropertyDate;

  MyAdvertisementPropertyModel(
      {this.id,
        this.name,
        this.categoryId,
        this.category,
        this.categoryImage,
        this.price,
        this.priceFormat,
        this.address,
        this.status,
        this.premiumProperty,
        this.propertyImage,
        this.isFavourite,
        this.propertyTypeId,
        this.propertyType,
        this.propertyFor,
        this.advertisementProperty,
        this.advertisementPropertyDate});

  MyAdvertisementPropertyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    category = json['category'];
    categoryImage = json['category_image'];
    price = json['price'];
    priceFormat = json['price_format'];
    address = json['address'];
    status = json['status'];
    premiumProperty = json['premium_property'];
    propertyImage = json['property_image'];
    isFavourite = json['is_favourite'];
    propertyTypeId = json['property_type_id'];
    propertyType = json['property_type'];
    propertyFor = json['property_for'];
    advertisementProperty = json['advertisement_property'];
    advertisementPropertyDate = json['advertisement_property_date'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['category'] = category;
    data['category_image'] = categoryImage;
    data['price'] = price;
    data['price_format'] = priceFormat;
    data['address'] = address;
    data['status'] = status;
    data['premium_property'] = premiumProperty;
    data['property_image'] = propertyImage;
    data['is_favourite'] = isFavourite;
    data['property_type_id'] = propertyTypeId;
    data['property_type'] = propertyType;
    data['property_for'] = propertyFor;
    data['advertisement_property'] = advertisementProperty;
    data['advertisement_property_date'] = advertisementPropertyDate;
    return data;
  }
}
