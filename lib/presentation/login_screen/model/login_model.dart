// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final int? status;
  final String? message;
  final Response? response;

  LoginModel({
    this.status,
    this.message,
    this.response,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    message: json["message"],
    response: json["response"] == null ? null : Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response?.toJson(),
  };
}

class Response {
  final String? id;
  final String? firstName;
  final String? email;
  final String? countryCode;
  final String? phone;
  final dynamic deactiveReason;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? lastName;
  final String? status;
  final dynamic companyId;
  final String? pin;
  final String? token;
  final String? fcmToken;
  final dynamic profileImage;

  Response({
    this.id,
    this.firstName,
    this.email,
    this.countryCode,
    this.phone,
    this.deactiveReason,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.lastName,
    this.status,
    this.companyId,
    this.pin,
    this.token,
    this.fcmToken,
    this.profileImage,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    id: json["id"],
    firstName: json["first_name"],
    email: json["email"],
    countryCode: json["country_code"],
    phone: json["phone"],
    deactiveReason: json["deactive_reason"],
    deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    lastName: json["last_name"],
    status: json["status"],
    companyId: json["company_id"],
    pin: json["pin"],
    token: json["token"],
    fcmToken: json["fcm_token"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "email": email,
    "country_code": countryCode,
    "phone": phone,
    "deactive_reason": deactiveReason,
    "deleted_at": deletedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "last_name": lastName,
    "status": status,
    "company_id": companyId,
    "pin": pin,
    "token": token,
    "fcm_token": fcmToken,
    "profile_image": profileImage,
  };
}
