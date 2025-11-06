class PropertyResponseModel {
  bool? status;
  Pagination? pagination;
  List<Property>? data;

  PropertyResponseModel({this.status, this.pagination, this.data});

  factory PropertyResponseModel.fromJson(Map<String, dynamic> json) {
    return PropertyResponseModel(
      status: json['status'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      data:
          (json['data'] as List?)?.map((x) => Property.fromJson(x)).toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'pagination': pagination?.toJson(),
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class Pagination {
  int? totalItems;
  int? perPage;
  int? currentPage;
  int? totalPages;

  Pagination(
      {this.totalItems, this.perPage, this.currentPage, this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalItems: json['total_items'],
      perPage: json['per_page'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_items': totalItems,
      'per_page': perPage,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}

class Property {
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
  String? priceDuration;
  String? propertyImage;
  int? isFavourite;
  int? propertyFor;
  String? advertisementProperty;
  String? advertisementPropertyDate;

  Property({
    this.id,
    this.name,
    this.categoryId,
    this.category,
    this.categoryImage,
    this.price,
    this.priceFormat,
    this.address,
    this.status,
    this.premiumProperty,
    this.priceDuration,
    this.propertyImage,
    this.isFavourite,
    this.propertyFor,
    this.advertisementProperty,
    this.advertisementPropertyDate,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      category: json['category'],
      categoryImage: json['category_image'],
      price: json['price'],
      priceFormat: json['price_format'],
      address: json['address'],
      status: json['status'],
      premiumProperty: json['premium_property'],
      priceDuration: json['price_duration'],
      propertyImage: json['property_image'],
      isFavourite: json['is_favourite'],
      propertyFor: json['property_for'],
      advertisementProperty: json['advertisement_property'].toString(),
      advertisementPropertyDate: json['advertisement_property_date'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'category': category,
      'category_image': categoryImage,
      'price': price,
      'price_format': priceFormat,
      'address': address,
      'status': status,
      'premium_property': premiumProperty,
      'price_duration': priceDuration,
      'property_image': propertyImage,
      'is_favourite': isFavourite,
      'property_for': propertyFor,
      'advertisement_property': advertisementProperty,
      'advertisement_property_date': advertisementPropertyDate,
    };
  }
}
