class AmenityDynamicModel {
  int? dynamicAmenityId;
  dynamic dynamicAmenityValue;
  // List<String>? dynamicAmenityValues;

  AmenityDynamicModel({
    this.dynamicAmenityId,
    this.dynamicAmenityValue,
    // this.dynamicAmenityValues,
  });

  AmenityDynamicModel.fromJson(Map<String, dynamic> json) {
    dynamicAmenityId = json['id'];
    dynamicAmenityValue = json['value'];
    // dynamicAmenityValues = json['value'] == null ? null : json['value'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = dynamicAmenityId;
    data['value'] = dynamicAmenityValue;
    // data['value'] = this.dynamicAmenityValues;
    return data;
  }
}
