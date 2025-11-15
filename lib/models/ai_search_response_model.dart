import 'dashBoard_response.dart';

class AiSearchResponse {
  String? message;
  AiSearchData? data;

  AiSearchResponse({this.message, this.data});

  AiSearchResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? AiSearchData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AiSearchData {
  bool? status;
  List<Property>? propertyData;
  List<Property>? nearByProperty;

  AiSearchData({this.status, this.propertyData, this.nearByProperty});

  AiSearchData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      propertyData = <Property>[];
      json['data'].forEach((v) {
        AiSearchData._normalizePropertyData(v);
        propertyData!.add(Property.fromJson(v));
      });
    }
    if (json['near_by_property'] != null) {
      nearByProperty = <Property>[];
      json['near_by_property'].forEach((v) {
        AiSearchData._normalizePropertyData(v);
        nearByProperty!.add(Property.fromJson(v));
      });
    }
  }

  static void _normalizePropertyData(Map<String, dynamic> v) {
    // Convert string numbers to int
    if (v['id'] is String) {
      v['id'] = int.tryParse(v['id']) ?? 0;
    }
    if (v['category_id'] is String) {
      v['category_id'] = int.tryParse(v['category_id']) ?? 0;
    }
    if (v['price'] is String) {
      v['price'] = int.tryParse(v['price']) ?? 0;
    }
    if (v['property_type_id'] != null && v['property_type_id'] is String) {
      v['property_type_id'] = int.tryParse(v['property_type_id']);
    }

    // Convert boolean premium_property to int if needed
    if (v['premium_property'] is bool) {
      v['premium_property'] = (v['premium_property'] as bool) ? 1 : 0;
    }

    // Convert boolean advertisement_property to int if needed
    if (v['advertisement_property'] is bool) {
      v['advertisement_property'] =
          (v['advertisement_property'] as bool) ? 1 : 0;
    }

    // Convert boolean is_favourite to int if needed
    if (v['is_favourite'] is bool) {
      v['is_favourite'] = (v['is_favourite'] as bool) ? 1 : 0;
    }

    // Handle status - if it's a string that's not a number, set to null or 0
    if (v['status'] is String) {
      // Try to parse as int, if it fails (like "متاح"), set to null
      int? statusInt = int.tryParse(v['status']);
      v['status'] = statusInt;
    }

    // Handle property_for - if it's a string that's not a number, set to null
    if (v['property_for'] != null && v['property_for'] is String) {
      int? propertyForInt = int.tryParse(v['property_for']);
      v['property_for'] = propertyForInt;
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
