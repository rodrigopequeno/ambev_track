import 'package:hive/hive.dart';

import '../../domain/entities/collect.dart';

class CollectModel extends Collect {
  const CollectModel({
    required DateTime dateTime,
    required Duration duration,
    required double latitude,
    required double longitude,
  }) : super(
          dateTime: dateTime,
          duration: duration,
          latitude: latitude,
          longitude: longitude,
        );

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime.millisecondsSinceEpoch,
      'duration': duration.inMilliseconds,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory CollectModel.fromMap(Map<String, dynamic> map) {
    return CollectModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      duration: Duration(milliseconds: map['duration']),
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

class CollectModelAdapter extends TypeAdapter<CollectModel> {
  @override
  final int typeId = 1;

  @override
  CollectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollectModel(
      dateTime: fields[0] as DateTime,
      duration: fields[1] as Duration,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CollectModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}