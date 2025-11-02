import '../models/category_list_model.dart';

class PropertyDetailsModel {
  PropertyDetail? data;
  List<AmenityName>? propertyAmenityValue;
  Customer? customer;
  NearByPlace? nearByPlace;

  PropertyDetailsModel({this.data, this.propertyAmenityValue, this.customer, this.nearByPlace});

  PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? PropertyDetail.fromJson(json['data']) : null;

    if (json['property_amenity_value'] != null) {
      propertyAmenityValue = <AmenityName>[];
      json['property_amenity_value'].forEach((v) {
        propertyAmenityValue!.add(AmenityName.fromJson(v));
      });
    }

    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;

    // nearByPlace = json['near_by_place'] != null ? new NearByPlace.fromJson(json['near_by_place']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (propertyAmenityValue != null) {
      data['property_amenity_value'] = propertyAmenityValue!.map((v) => v.toJson()).toList();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (nearByPlace != null) {
      data['near_by_place'] = nearByPlace!.toJson();
    }
    return data;
  }
}

class PropertyDetail {
  int? id;
  String? name;
  int? categoryId;
  String? category;
  String? categoryImage;
  int? propertyTypeId;
  String? propertyType;
  int? price;
  String? priceFormat;
  int? furnishedType;
  int? sallerType;
  int? propertyFor;
  String? priceDuration;
  num? ageOfProperty;
  int? maintenance;
  int? securityDeposit;
  int? brokerage;
  int? bhk;
  String? sqft;
  String? description;
  String? country;
  String? state;
  String? city;
  String? latitude;
  String? longitude;
  String? address;
  dynamic videoUrl;
  int? status;
  int? premiumProperty;
  String? propertyImage;
  List<dynamic>? propertyGallary;
  List<PropertyGallaryArray>? propertyGallaryArray;
  String? createdAt;
  String? updatedAt;
  int? isFavourite;
  int? advertisementProperty;
  String? advertisementPropertyDate;
  int? checkedPropertyInquiry;

  PropertyDetail(
      {this.id,
      this.name,
      this.categoryId,
      this.category,
      this.categoryImage,
      this.price,
      this.priceFormat,
      this.furnishedType,
      this.sallerType,
      this.propertyFor,
      this.priceDuration,
      this.ageOfProperty,
      this.maintenance,
      this.securityDeposit,
      this.brokerage,
      this.bhk,
      this.sqft,
      this.description,
      this.country,
      this.state,
      this.city,
      this.latitude,
      this.longitude,
      this.address,
      this.videoUrl,
      this.status,
      this.premiumProperty,
      this.propertyImage,
      this.propertyGallary,
      this.propertyGallaryArray,
      this.createdAt,
      this.updatedAt,
      this.isFavourite,
      this.advertisementProperty,
      this.advertisementPropertyDate,
      this.checkedPropertyInquiry});

  PropertyDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    name = json['name'];
    categoryId = json['category_id'];
    category = json['category'];
    categoryImage = json['category_image'];
    price = json['price'];
    priceFormat = json['price_format'];
    furnishedType = json['furnished_type'];
    sallerType = json['saller_type'];
    propertyFor = json['property_for'];
    priceDuration = json['price_duration'];
    ageOfProperty = json['age_of_property'];
    maintenance = json['maintenance'];
    securityDeposit = json['security_deposit'];

    brokerage = json['brokerage'];
    bhk = json['bhk'];
    sqft = json['sqft'];
    description = json['description'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    videoUrl = json['video_url'];
    status = json['status'];
    premiumProperty = json['premium_property'];

    propertyImage = json['property_image'];
    propertyGallary = json['property_gallary'].cast<String>();

    if (json['property_gallary_array'] != null) {
      propertyGallaryArray = <PropertyGallaryArray>[];
      json['property_gallary_array'].forEach((v) {
        propertyGallaryArray!.add(PropertyGallaryArray.fromJson(v));
      });
    }

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isFavourite = json['is_favourite'];
    advertisementProperty = json['advertisement_property'];
    advertisementPropertyDate = json['advertisement_property_date'];
    checkedPropertyInquiry = json['checked_property_inquiry'];
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
    data['furnished_type'] = furnishedType;
    data['saller_type'] = sallerType;
    data['property_for'] = propertyFor;
    data['price_duration'] = priceDuration;
    data['age_of_property'] = ageOfProperty;
    data['maintenance'] = maintenance;
    data['security_deposit'] = securityDeposit;
    data['brokerage'] = brokerage;
    data['bhk'] = bhk;
    data['sqft'] = sqft;
    data['description'] = description;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['video_url'] = videoUrl;
    data['status'] = status;
    data['premium_property'] = premiumProperty;
    data['property_image'] = propertyImage;
    data['property_gallary'] = propertyGallary;
    if (propertyGallaryArray != null) {
      data['property_gallary_array'] = propertyGallaryArray!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_favourite'] = isFavourite;
    data['advertisement_property'] = advertisementProperty;
    data['advertisement_property_date'] = advertisementPropertyDate;
    data['checked_property_inquiry'] = checkedPropertyInquiry;
    return data;
  }
}

class PropertyGallaryArray {
  int? id;
  String? url;

  PropertyGallaryArray({this.id, this.url});

  PropertyGallaryArray.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}

// class PropertyAmenityValue {
//   int? id;
//   int? propertyId;
//   int? amenityId;
//   String? name;
//   String? type;
//
//   // String? value;
//   dynamic value;
//   String? amenityImage;
//
//   PropertyAmenityValue({this.id, this.propertyId, this.amenityId, this.name, this.type, this.value, this.amenityImage});
//
//   PropertyAmenityValue.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     // propertyId = json['property_id'];
//     print("-------------+++property_id Clar");
//     // amenityId = json['amenity_id'];
//     print("-------------++++amenity_id Clar");
//     name = json['name'];
//     // type = json['type'];
//     // value = json['value'];
//     print("-------------++++value Clar");
//     amenityImage = json['amenity_image'];
//     print("-------------++++++amenity_image Clar");
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['property_id'] = this.propertyId;
//     data['amenity_id'] = this.amenityId;
//     data['name'] = this.name;
//     data['type'] = this.type;
//     data['value'] = this.value;
//     data['amenity_image'] = this.amenityImage;
//     return data;
//   }
// }

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  String? contactNumber;
  String? profileImage;
  int? isAgent;
  int? isBuilder;

  Customer({this.id, this.firstName, this.lastName, this.email, this.address, this.contactNumber, this.profileImage, this.isAgent, this.isBuilder});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    address = json['address'];

    contactNumber = json['contact_number'];
    profileImage = json['profile_image'];
    isAgent = json['is_agent'];
    isBuilder = json['is_builder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['address'] = address;
    data['contact_number'] = contactNumber;
    data['profile_image'] = profileImage;
    data['is_agent'] = isAgent;
    data['is_builder'] = isBuilder;
    return data;
  }
}

class NearByPlace {
  List<Results>? results;
  String? status;

  NearByPlace({this.results, this.status});

  NearByPlace.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Results {
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  List<Photos>? photos;
  String? placeId;
  String? reference;
  String? scope;
  List<String>? types;
  String? vicinity;
  String? businessStatus;
  dynamic rating;
  int? userRatingsTotal;
  bool? permanentlyClosed;
  PlusCode? plusCode;
  OpeningHours? openingHours;

  Results(
      {this.geometry,
      this.icon,
      this.iconBackgroundColor,
      this.iconMaskBaseUri,
      this.name,
      this.photos,
      this.placeId,
      this.reference,
      this.scope,
      this.types,
      this.vicinity,
      this.businessStatus,
      this.rating,
      this.userRatingsTotal,
      this.permanentlyClosed,
      this.plusCode,
      this.openingHours});

  Results.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(Photos.fromJson(v));
      });
    }
    placeId = json['place_id'];
    reference = json['reference'];
    scope = json['scope'];
    types = json['types'].cast<String>();
    vicinity = json['vicinity'];
    businessStatus = json['business_status'];
    rating = json['rating'];
    userRatingsTotal = json['user_ratings_total'];
    permanentlyClosed = json['permanently_closed'];
    plusCode = json['plus_code'] != null ? PlusCode.fromJson(json['plus_code']) : null;
    openingHours = json['opening_hours'] != null ? OpeningHours.fromJson(json['opening_hours']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    data['icon'] = icon;
    data['icon_background_color'] = iconBackgroundColor;
    data['icon_mask_base_uri'] = iconMaskBaseUri;
    data['name'] = name;
    if (photos != null) {
      data['photos'] = photos!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = placeId;
    data['reference'] = reference;
    data['scope'] = scope;
    data['types'] = types;
    data['vicinity'] = vicinity;
    data['business_status'] = businessStatus;
    data['rating'] = rating;
    data['user_ratings_total'] = userRatingsTotal;
    data['permanently_closed'] = permanentlyClosed;
    if (plusCode != null) {
      data['plus_code'] = plusCode!.toJson();
    }
    if (openingHours != null) {
      data['opening_hours'] = openingHours!.toJson();
    }
    return data;
  }
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    viewport = json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (viewport != null) {
      data['viewport'] = viewport!.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['c'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null ? Location.fromJson(json['northeast']) : null;
    southwest = json['southwest'] != null ? Location.fromJson(json['southwest']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (northeast != null) {
      data['northeast'] = northeast!.toJson();
    }
    if (southwest != null) {
      data['southwest'] = southwest!.toJson();
    }
    return data;
  }
}

class Photos {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['height'] = height;
    data['html_attributions'] = htmlAttributions;
    data['photo_reference'] = photoReference;
    data['width'] = width;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['compound_code'] = compoundCode;
    data['global_code'] = globalCode;
    return data;
  }
}

class OpeningHours {
  bool? openNow;

  OpeningHours({this.openNow});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['open_now'] = openNow;
    return data;
  }
}
