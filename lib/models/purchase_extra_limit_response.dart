class PurchaseExtraLimitResponse {
  Data? data;

  PurchaseExtraLimitResponse({this.data});

  PurchaseExtraLimitResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? displayName;
  String? email;
  String? username;
  String? status;
  String? userType;
  String? address;
  String? contactNumber;
  String? profileImage;
  String? loginType;
  String? latitude;
  String? longitude;
  String? uid;
  String? playerId;
  String? timezone;
  String? isAgent;
  String? isBuilder;
  String? lastNotificationSeen;
  int? isSubscribe;
  int? viewLimitCount;
  int? addLimitCount;
  int? advertisementLimit;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.displayName,
        this.email,
        this.username,
        this.status,
        this.userType,
        this.address,
        this.contactNumber,
        this.profileImage,
        this.loginType,
        this.latitude,
        this.longitude,
        this.uid,
        this.playerId,
        this.timezone,
        this.isAgent,
        this.isBuilder,
        this.lastNotificationSeen,
        this.isSubscribe,
        this.viewLimitCount,
        this.addLimitCount,
        this.advertisementLimit,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    email = json['email'];
    username = json['username'];
    status = json['status'];
    userType = json['user_type'];
    address = json['address'];
    contactNumber = json['contact_number'];
    profileImage = json['profile_image'];
    loginType = json['login_type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    uid = json['uid'];
    playerId = json['player_id'];
    timezone = json['timezone'];
    isAgent = json['is_agent'];
    isBuilder = json['is_builder'];
    lastNotificationSeen = json['last_notification_seen'];
    isSubscribe = json['is_subscribe'];
    viewLimitCount = json['view_limit_count'];
    addLimitCount = json['add_limit_count'];
    advertisementLimit = json['advertisement_limit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['display_name'] = displayName;
    data['email'] = email;
    data['username'] = username;
    data['status'] = status;
    data['user_type'] = userType;
    data['address'] = address;
    data['contact_number'] = contactNumber;
    data['profile_image'] = profileImage;
    data['login_type'] = loginType;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['uid'] = uid;
    data['player_id'] = playerId;
    data['timezone'] = timezone;
    data['is_agent'] = isAgent;
    data['is_builder'] = isBuilder;
    data['last_notification_seen'] = lastNotificationSeen;
    data['is_subscribe'] = isSubscribe;
    data['view_limit_count'] = viewLimitCount;
    data['add_limit_count'] = addLimitCount;
    data['advertisement_limit'] = advertisementLimit;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
