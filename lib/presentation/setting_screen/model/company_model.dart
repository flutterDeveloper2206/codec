// To parse this JSON data, do
//
//      companyModel = companyModelFromJson(jsonString);

import 'dart:convert';

CompanyModel companyModelFromJson(String str) => CompanyModel.fromJson(json.decode(str));

String companyModelToJson(CompanyModel data) => json.encode(data.toJson());

class CompanyModel {
   int? status;
   String? message;
   List<CompanyData>? response;

  CompanyModel({
    this.status,
    this.message,
    this.response,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
    status: json["status"],
    message: json["message"],
    response: json["response"] == null ? [] : List<CompanyData>.from(json["response"]!.map((x) => CompanyData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response == null ? [] : List<dynamic>.from(response!.map((x) => x.toJson())),
  };
}

class CompanyData {
   String? id;
   String? name;
   String? email;
   String? address;
   String? countryCode;
   String? phone;
   String? countryId;
   String? provinceId;
   String? cityId;
   dynamic deletedAt;
   DateTime? createdAt;
   DateTime? updatedAt;
   dynamic profileImage;

  CompanyData({
    this.id,
    this.name,
    this.email,
    this.address,
    this.countryCode,
    this.phone,
    this.countryId,
    this.provinceId,
    this.cityId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.profileImage,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) => CompanyData(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    address: json["address"],
    countryCode: json["country_code"],
    phone: json["phone"],
    countryId: json["country_id"],
    provinceId: json["province_id"],
    cityId: json["city_id"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "address": address,
    "country_code": countryCode,
    "phone": phone,
    "country_id": countryId,
    "province_id": provinceId,
    "city_id": cityId,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "profile_image": profileImage,
  };
}
