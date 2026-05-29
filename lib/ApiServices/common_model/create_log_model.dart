import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

part 'create_log_model.g.dart';

@HiveType(typeId: 0)
class CreateLog {
  @HiveField(0)
  final String? logNumber;

  @HiveField(1)
  final String? testType;
  @HiveField(2)
  final String? fullName;
  @HiveField(3)
  final String? pTSNumber;
  @HiveField(4)
  final String? companyName;
  @HiveField(5)
  final String? formBNumber;
  @HiveField(6)
  final String? formCNumber;
  @HiveField(7)
  final String? location;
  @HiveField(8)
  final String? gpsLocation;
  @HiveField(9)
  final String? deviceSerialNumber;
  @HiveField(10)
  final String? startUp;
  @HiveField(11)
  final String? voltsDetected;
  @HiveField(12)
  final String? duration;
  @HiveField(13)
  final String? voltsHighest;
  @HiveField(14)
  final String? voltsLowest;
  @HiveField(15)
  final String? notes;
  @HiveField(16)
  final String? photoPath;
  @HiveField(17)
  final String? date;
  @HiveField(18)
  final String? isBatteryCalibration;
 @HiveField(19)
  final String? isInductionEnr;

  CreateLog(
      {this.fullName,
      this.pTSNumber,
      this.companyName,
      this.formBNumber,
      this.formCNumber,
      this.location,
      this.gpsLocation,
      this.deviceSerialNumber,
      this.logNumber,
      this.testType,
      this.startUp,
      this.voltsDetected,
      this.duration,
      this.voltsHighest,
      this.voltsLowest,
      this.notes,
        this.date,
        this.isBatteryCalibration,
        this.isInductionEnr,
        this.photoPath
      });
}
