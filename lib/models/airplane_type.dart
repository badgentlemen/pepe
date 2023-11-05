import 'dart:ui';

enum AirplaneType {
  /// химикаты
  chemical,

  /// удобрения
  manure,
}


extension AirplaneTypeExt on AirplaneType {
  // NOTE: можно потом поменять на разные значения
  int get price {
    switch (this) {
      case AirplaneType.chemical:
        return 200;
      case AirplaneType.manure:
        return 200;
    }
  }

  String get title {
    switch (this) {
      case AirplaneType.chemical:
        return 'Химикаты';
      case AirplaneType.manure:
        return 'Удобрения';
    }
  }

  Color get color {
    switch (this) {
      case AirplaneType.chemical:
        return const Color(0xFFE3585D);
      case AirplaneType.manure:
        return const Color(0xFF84B941);
    }
  }
}