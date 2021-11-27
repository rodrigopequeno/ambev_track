import 'package:hive/hive.dart';

import '../../../../core/error/exceptions/invalid_geographic_coordinate_exception.dart';
import '../../domain/entities/cardinal_point.dart';
import '../../domain/entities/geographic_coordinate.dart';

class GeographicCoordinateModel extends GeographicCoordinate {
  GeographicCoordinateModel({
    required double degrees,
    required CardinalPoint cardinalPoint,
    double minutes = 0,
    double seconds = 0,
  }) : super(
          cardinalPoint: cardinalPoint,
          degrees: degrees,
          minutes: minutes,
          seconds: seconds,
        ) {
    if (!_isValid(degrees: degrees, cardinalPoint: cardinalPoint)) {
      throw InvalidGeographicCoordinateException(
        degrees: degrees,
        cardinalPoint: cardinalPoint,
      );
    }
  }

  factory GeographicCoordinateModel.fromDecimal({
    required double decimalCoordinate,
    required CardinalPoint cardinalPoint,
  }) {
    final absoluteCoordinate = decimalCoordinate.abs();
    assert(absoluteCoordinate >= 0);
    final degrees = absoluteCoordinate.floor();
    final deltaDegrees = absoluteCoordinate - degrees;
    final minutesDecimal = deltaDegrees * 60;

    final minutes = minutesDecimal.floor();
    final deltaMinutes = minutesDecimal - minutes;
    final seconds = deltaMinutes * 60;
    return GeographicCoordinateModel(
      degrees: degrees.toDouble(),
      minutes: minutes.toDouble(),
      seconds: seconds,
      cardinalPoint: cardinalPoint,
    );
  }

  bool _isValid({
    required double degrees,
    required CardinalPoint cardinalPoint,
  }) {
    switch (cardinalPoint) {
      case CardinalPoint.south:
      case CardinalPoint.north:
        if (0 <= degrees && degrees <= 90) {
          return true;
        }
        return false;
      case CardinalPoint.west:
      case CardinalPoint.east:
        if (0 <= degrees && degrees <= 180) {
          return true;
        }
        return false;
    }
  }

  double toDecimal() {
    final decimal = (degrees + (minutes / 60) + (seconds / 3600));
    if (cardinalPoint == CardinalPoint.south ||
        cardinalPoint == CardinalPoint.west) {
      return decimal * -1;
    }
    return decimal;
  }

  Map<String, dynamic> toMap() {
    return {
      'degrees': degrees,
      'minutes': minutes,
      'seconds': seconds,
      'cardinalPoint': cardinalPoint.symbol,
    };
  }

  factory GeographicCoordinateModel.fromMap(Map<String, dynamic> map) {
    return GeographicCoordinateModel(
      degrees: map['degrees'].toDouble(),
      minutes: map['minutes'].toDouble(),
      seconds: map['seconds'].toDouble(),
      cardinalPoint: CardinalPointExtension.fromSymbol(map['cardinalPoint']),
    );
  }

  @override
  String toString() =>
      '''${degrees.toInt()}°${minutes.toInt()}'${seconds.toStringAsFixed(2)}"${cardinalPoint.symbol}''';
}

class GeographicCoordinateModelAdapter
    extends TypeAdapter<GeographicCoordinateModel> {
  @override
  final int typeId = 2;

  @override
  GeographicCoordinateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeographicCoordinateModel(
      cardinalPoint: fields[0] as CardinalPoint,
      degrees: fields[1] as double,
      minutes: fields[2] as double,
      seconds: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, GeographicCoordinateModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cardinalPoint)
      ..writeByte(1)
      ..write(obj.degrees)
      ..writeByte(2)
      ..write(obj.minutes)
      ..writeByte(3)
      ..write(obj.seconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeographicCoordinateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
