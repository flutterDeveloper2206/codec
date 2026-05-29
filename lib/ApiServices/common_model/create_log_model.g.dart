// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreateLogAdapter extends TypeAdapter<CreateLog> {
  @override
  final int typeId = 0;

  @override
  CreateLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreateLog(
      fullName: fields[2] as String?,
      pTSNumber: fields[3] as String?,
      companyName: fields[4] as String?,
      formBNumber: fields[5] as String?,
      formCNumber: fields[6] as String?,
      location: fields[7] as String?,
      gpsLocation: fields[8] as String?,
      deviceSerialNumber: fields[9] as String?,
      logNumber: fields[0] as String?,
      testType: fields[1] as String?,
      startUp: fields[10] as String?,
      voltsDetected: fields[11] as String?,
      duration: fields[12] as String?,
      voltsHighest: fields[13] as String?,
      voltsLowest: fields[14] as String?,
      notes: fields[15] as String?,
      photoPath: fields[16] as String?,
      date: fields[17] as String?,
      isBatteryCalibration: fields[18] as String?,
      isInductionEnr: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CreateLog obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.logNumber)
      ..writeByte(1)
      ..write(obj.testType)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.pTSNumber)
      ..writeByte(4)
      ..write(obj.companyName)
      ..writeByte(5)
      ..write(obj.formBNumber)
      ..writeByte(6)
      ..write(obj.formCNumber)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.gpsLocation)
      ..writeByte(9)
      ..write(obj.deviceSerialNumber)
      ..writeByte(10)
      ..write(obj.startUp)
      ..writeByte(11)
      ..write(obj.voltsDetected)
      ..writeByte(12)
      ..write(obj.duration)
      ..writeByte(13)
      ..write(obj.voltsHighest)
      ..writeByte(14)
      ..write(obj.voltsLowest)
      ..writeByte(15)
      ..write(obj.notes)
      ..writeByte(16)
      ..write(obj.photoPath)
      ..writeByte(17)
      ..write(obj.date)
      ..writeByte(18)
      ..write(obj.isBatteryCalibration)
      ..writeByte(19)
      ..write(obj.isInductionEnr);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
