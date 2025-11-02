class LogInResponse {
  Data? data;

  LogInResponse({this.data});

  LogInResponse.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? username;
  String? contactNumber;
  String? emailVerifiedAt;
  String? address;
  String? userType;
  int? isAgent;
  int? isBuilder;
  String? playerId;
  String? fcmToken;
  String? latitude;
  String? longitude;
  String? lastNotificationSeen;
  String? status;
  String? uid;
  String? displayName;
  String? loginType;
  String? otpVerifyAt;
  String? timezone;
  String? createdAt;
  String? updatedAt;
  String? apiToken;
  String? profileImage;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.username,
        this.contactNumber,
        this.emailVerifiedAt,
        this.address,
        this.userType,
        this.isAgent,
        this.isBuilder,
        this.playerId,
        this.fcmToken,
        this.latitude,
        this.longitude,
        this.lastNotificationSeen,
        this.status,
        this.uid,
        this.displayName,
        this.loginType,
        this.otpVerifyAt,
        this.timezone,
        this.createdAt,
        this.updatedAt,
        this.apiToken,
        this.profileImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    username = json['username'];
    contactNumber = json['contact_number'];
    emailVerifiedAt = json['email_verified_at'];
    address = json['address'];
    userType = json['user_type'];
    isAgent = json['is_agent'];
    isBuilder = json['is_builder'];
    playerId = json['player_id'];
    fcmToken = json['fcm_token'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    lastNotificationSeen = json['last_notification_seen'];
    status = json['status'];
    uid = json['uid'];
    displayName = json['display_name'];
    loginType = json['login_type'];
    otpVerifyAt = json['otp_verify_at'];
    timezone = json['timezone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    apiToken = json['api_token'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['username'] = username;
    data['contact_number'] = contactNumber;
    data['email_verified_at'] = emailVerifiedAt;
    data['address'] = address;
    data['user_type'] = userType;
    data['is_agent'] = isAgent;
    data['is_builder'] = isBuilder;
    data['player_id'] = playerId;
    data['fcm_token'] = fcmToken;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['last_notification_seen'] = lastNotificationSeen;
    data['status'] = status;
    data['uid'] = uid;
    data['display_name'] = displayName;
    data['login_type'] = loginType;
    data['otp_verify_at'] = otpVerifyAt;
    data['timezone'] = timezone;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['api_token'] = apiToken;
    data['profile_image'] = profileImage;
    return data;
  }
}
