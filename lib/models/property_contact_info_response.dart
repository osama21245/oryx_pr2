import 'pagination_model.dart';

class PropertyContactInfoResponse {
  Pagination? pagination;
  List<ContactInfoModel>? data;

  PropertyContactInfoResponse({this.pagination, this.data});

  PropertyContactInfoResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = <ContactInfoModel>[];
      json['data'].forEach((v) {
        data!.add(ContactInfoModel.fromJson(v));
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

class ContactInfoModel {
  int? id;
  int? propertyId;
  int? customerId;
  String? propertyName;
  String? customerName;
  String? customerProfileImage;
  String? contactNumber;
  String? createdAt;
  String? updatedAt;

  ContactInfoModel({this.id, this.customerId, this.customerName, this.customerProfileImage, this.createdAt, this.updatedAt});

  ContactInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    customerId = json['customer_id'];
    propertyName = json['property_name'];
    customerName = json['customer_name'];
    customerProfileImage = json['customer_profile_image'];
    contactNumber = json['contact_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['property_id'] = propertyId;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['property_name'] = propertyName;
    data['contact_number'] = contactNumber;
    data['customer_profile_image'] = customerProfileImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
