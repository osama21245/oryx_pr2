// class EPropertyBaseResponse {
//   String? message;
//
//   EPropertyBaseResponse({this.message});
//
//   EPropertyBaseResponse.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     return data;
//   }
// }

class EPropertyBaseResponse {
  String? message;
  bool? status;
  int? propertyId;

  EPropertyBaseResponse({this.message, this.propertyId, this.status});

  EPropertyBaseResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    propertyId = json['property_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['property_id'] = propertyId;
    return data;
  }
}
