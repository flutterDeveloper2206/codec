// To parse this JSON data, do
//
//      departMentAndTestTypeModel = departMentAndTestTypeModelFromJson(jsonString);

import 'dart:convert';

DepartMentAndTestTypeModel departMentAndTestTypeModelFromJson(String str) => DepartMentAndTestTypeModel.fromJson(json.decode(str));

String departMentAndTestTypeModelToJson(DepartMentAndTestTypeModel data) => json.encode(data.toJson());

class DepartMentAndTestTypeModel {
   int? status;
   String? message;
   List<DepData>? response;

  DepartMentAndTestTypeModel({
    this.status,
    this.message,
    this.response,
  });

  factory DepartMentAndTestTypeModel.fromJson(Map<String, dynamic> json) => DepartMentAndTestTypeModel(
    status: json["status"],
    message: json["message"],
    response: json["response"] == null ? [] : List<DepData>.from(json["response"]!.map((x) => DepData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response == null ? [] : List<dynamic>.from(response!.map((x) => x.toJson())),
  };
}

class DepData {
   String? id;
   String? name;
   dynamic deletedAt;
   DateTime? createdAt;
   DateTime? updatedAt;

  DepData({
    this.id,
    this.name,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory DepData.fromJson(Map<String, dynamic> json) => DepData(
    id: json["id"],
    name: json["name"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
