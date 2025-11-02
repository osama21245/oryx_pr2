

import 'dashBoard_response.dart';

class SearchResponse {
  bool? status;
  List<Property>? propertyData;
  List<Property>? nearByProperty;

  SearchResponse({this.status, this.propertyData, this.nearByProperty});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      propertyData = <Property>[];
      json['data'].forEach((v) {
        propertyData!.add(Property.fromJson(v));
      });
    }
    if (json['near_by_property'] != null) {
      nearByProperty = <Property>[];
      json['near_by_property'].forEach((v) {
        nearByProperty!.add(Property.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (propertyData != null) {
      data['data'] = propertyData!.map((v) => v.toJson()).toList();
    }
    if (nearByProperty != null) {
      data['near_by_property'] =
          nearByProperty!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NearByProperty {
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

  NearByProperty(
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
        this.propertyFor});

  NearByProperty.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
