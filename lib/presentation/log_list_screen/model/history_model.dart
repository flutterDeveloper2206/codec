// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

HistoryModel historyModelFromJson(String str) => HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  final int? status;
  final int? total;
  final String? message;
  final List<HistoryData>? response;

  HistoryModel({
    this.status,
    this.total,
    this.message,
    this.response,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
    status: json["status"],
    total: json["total"],
    message: json["message"],
    response: json["response"] == null ? [] : List<HistoryData>.from(json["response"]!.map((x) => HistoryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "total": total,
    "message": message,
    "response": response == null ? [] : List<dynamic>.from(response!.map((x) => x.toJson())),
  };
}

class HistoryData {
  final String? id;
  final String? userId;
  final String? logNumber;
  final String? testType;
  final String? fullName;
  final String? ptsNumber;
  final String? companyName;
  final String? formBNo;
  final String? formCNo;
  final String? location;
  final String? gpsLocation;
  final String? deviceSerialNumber;
  final String? startUp;
  final String? voltsDetected;
  final String? duration;
  final String? voltsHighest;
  final String? voltsLowest;
  final String? notes;
  final String? image;
  final String? date;
  final String? isBatteryCalibration;
  final String? isInductionEnr;
  final int? isVisible;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;

  HistoryData({
    this.id,
    this.userId,
    this.logNumber,
    this.testType,
    this.fullName,
    this.ptsNumber,
    this.companyName,
    this.formBNo,
    this.formCNo,
    this.location,
    this.gpsLocation,
    this.deviceSerialNumber,
    this.startUp,
    this.voltsDetected,
    this.duration,
    this.voltsHighest,
    this.voltsLowest,
    this.notes,
    this.image,
    this.date,
    this.isBatteryCalibration,
    this.isInductionEnr,
    this.isVisible,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
    id: json["id"],
    userId: json["user_id"],
    logNumber: json["log_number"],
    testType: json["test_type"],
    fullName: json["full_name"],
    ptsNumber: json["PTS_number"],
    companyName: json["company_name"],
    formBNo: json["form_b_no"],
    formCNo: json["form_c_no"],
    location: json["location"],
    gpsLocation: json["gps_location"],
    deviceSerialNumber: json["device_serial_number"],
    startUp: json["start_up"],
    voltsDetected: json["volts_detected"],
    duration: json["duration"],
    voltsHighest: json["volts_highest"],
    voltsLowest: json["volts_lowest"],
    notes: json["notes"],
    image: json["image"],
    date: json["date"] ,
    isBatteryCalibration: json["is_battery_calibration"],
    isInductionEnr: json["is_inductionEnr"],
    isVisible: json["is_visible"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "log_number": logNumber,
    "test_type": testType,
    "full_name": fullName,
    "PTS_number": ptsNumber,
    "company_name": companyName,
    "form_b_no": formBNo,
    "form_c_no": formCNo,
    "location": location,
    "gps_location": gpsLocation,
    "device_serial_number": deviceSerialNumber,
    "start_up": startUp,
    "volts_detected": voltsDetected,
    "duration": duration,
    "volts_highest": voltsHighest,
    "volts_lowest": voltsLowest,
    "notes": notes,
    "image": image,
    "date": date,
    "is_battery_calibration": isBatteryCalibration,
    "is_inductionEnr": isInductionEnr,
    "is_visible": isVisible,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image_url": imageUrl,
  };
}
