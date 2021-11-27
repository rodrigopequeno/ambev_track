import 'package:hive/hive.dart';

enum CardinalPoint {
  /// Latitude - North
  north,

  /// Latitude - South
  south,

  /// Longitude - East
  east,

  /// Longitude - West
  west,
}

extension CardinalPointExtension on CardinalPoint {
  String get symbol {
    switch (this) {
      case CardinalPoint.south:
        return "S";
      case CardinalPoint.north:
        return "N";
      case CardinalPoint.west:
        return "W";
      case CardinalPoint.east:
        return "E";
    }
  }

  static fromSymbol(String symbol) {
    return CardinalPoint.values.firstWhere(
      (element) => element.symbol.toUpperCase() == symbol.toUpperCase(),
      orElse: () {
        throw Exception();
      },
    );
  }
}

class CardinalPointAdapter extends TypeAdapter<CardinalPoint> {
  @override
  final int typeId = 3;

  @override
  CardinalPoint read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CardinalPoint.north;
      case 1:
        return CardinalPoint.south;
      case 2:
        return CardinalPoint.east;
      case 3:
        return CardinalPoint.west;
      default:
        return CardinalPoint.north;
    }
  }

  @override
  void write(BinaryWriter writer, CardinalPoint obj) {
    switch (obj) {
      case CardinalPoint.north:
        writer.writeByte(0);
        break;
      case CardinalPoint.south:
        writer.writeByte(1);
        break;
      case CardinalPoint.east:
        writer.writeByte(2);
        break;
      case CardinalPoint.west:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardinalPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
