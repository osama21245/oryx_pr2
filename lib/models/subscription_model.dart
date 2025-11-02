// import '../models/pagination_model.dart';
//
// class SubscriptionResponse {
//   Pagination? pagination;
//   List<SubscriptionModel>? data;
//
//   SubscriptionResponse({this.pagination, this.data});
//
//   SubscriptionResponse.fromJson(Map<String, dynamic> json) {
//     pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
//     if (json['data'] != null) {
//       data = <SubscriptionModel>[];
//       json['data'].forEach((v) {
//         data!.add(new SubscriptionModel.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.pagination != null) {
//       data['pagination'] = this.pagination!.toJson();
//     }
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class SubscriptionModel {
//   int? id;
//   String? name;
//   String? durationUnit;
//   int? duration;
//   double? price;
//   int? property;
//   int? advertisement;
//   int? propertyLimit;
//   int? advertisementLimit;
//   int? status;
//   String? description;
//   String? createdAt;
//   String? updatedAt;
//
//   SubscriptionModel(
//       {this.id,
//       this.name,
//       this.durationUnit,
//       this.duration,
//       this.price,
//       this.property,
//       this.advertisement,
//       this.propertyLimit,
//       this.advertisementLimit,
//       this.status,
//       this.description,
//       this.createdAt,
//       this.updatedAt});
//
//   SubscriptionModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     durationUnit = json['duration_unit'];
//     duration = json['duration'];
//     price = json['price'];
//     property = json['property'];
//     advertisement = json['advertisement'];
//     propertyLimit = json['property_limit'];
//     advertisementLimit = json['advertisement_limit'];
//     status = json['status'];
//     description = json['description'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['duration_unit'] = this.durationUnit;
//     data['duration'] = this.duration;
//     data['price'] = this.price;
//     data['property'] = this.property;
//     data['advertisement'] = this.advertisement;
//     data['property_limit'] = this.propertyLimit;
//     data['advertisement_limit'] = this.advertisementLimit;
//     data['status'] = this.status;
//     data['description'] = this.description;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
import 'pagination_model.dart';

class SubscriptionResponse {
  Pagination? pagination;
  List<SubscriptionModel>? data;

  SubscriptionResponse({this.pagination, this.data});

  SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <SubscriptionModel>[];
      json['data'].forEach((v) {
        data!.add(SubscriptionModel.fromJson(v));
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

class SubscriptionModel {
  int? id;
  String? name;
  String? durationUnit;
  int? duration;
  num? price;
  int? property;
  int? addProperty;
  int? advertisement;
  int? viewPropertyLimit;
  int? addPropertyLimit;
  int? advertisementLimit;
  int? status;
  String? description;
  String? createdAt;
  String? updatedAt;

  SubscriptionModel(
      {this.id,
        this.name,
        this.durationUnit,
        this.duration,
        this.price,
        this.property,
        this.addProperty,
        this.advertisement,
        this.viewPropertyLimit,
        this.addPropertyLimit,
        this.advertisementLimit,
        this.status,
        this.description,
        this.createdAt,
        this.updatedAt});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    durationUnit = json['duration_unit'];
    duration = json['duration'];
    price = json['price'];
    property = json['property'];
    addProperty = json['add_property'];
    advertisement = json['advertisement'];
    viewPropertyLimit = json['view_property_limit'];
    addPropertyLimit = json['add_property_limit'];
    advertisementLimit = json['advertisement_limit'];
    status = json['status'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['duration_unit'] = durationUnit;
    data['duration'] = duration;
    data['price'] = price;
    data['property'] = property;
    data['add_property'] = addProperty;
    data['advertisement'] = advertisement;
    data['view_property_limit'] = viewPropertyLimit;
    data['add_property_limit'] = addPropertyLimit;
    data['advertisement_limit'] = advertisementLimit;
    data['status'] = status;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
