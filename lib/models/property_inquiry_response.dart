import 'pagination_model.dart';

class PropertyInquiryResponse {
  Pagination? pagination;
  List<PropertyInquiryModel>? data;

  PropertyInquiryResponse({this.pagination, this.data});

  PropertyInquiryResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <PropertyInquiryModel>[];
      json['data'].forEach((v) {
        data!.add(PropertyInquiryModel.fromJson(v));
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

class PropertyInquiryModel {
  int? id;
  int? propertyId;
  String? propertyName;
  String? propertyImage;
  int? customerId;
  String? customerName;
  String? createdAt;
  String? updatedAt;

  PropertyInquiryModel({this.id, this.propertyId, this.propertyName, this.propertyImage, this.customerId, this.customerName, this.createdAt, this.updatedAt});

  PropertyInquiryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    propertyName = json['property_name'];
    propertyImage = json['property_image'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['property_id'] = propertyId;
    data['property_name'] = propertyName;
    data['property_image'] = propertyImage;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
