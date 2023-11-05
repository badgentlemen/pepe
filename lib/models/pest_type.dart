import 'package:flame/components.dart';

enum PestType {
  bunny,
  snail,
  turtle,
}

extension PestTypeExt on PestType {
  int get damage {
    switch (this) {
      case PestType.bunny:
        return 20;
      case PestType.snail:
        return 15;
      case PestType.turtle:
        return 8;
    }
  }

  int get dodgePercent {
    switch (this) {
      case PestType.bunny:
        return 36;
      case PestType.snail:
        return 24;
      case PestType.turtle:
        return 12;
    }
  }

  String get title {
    switch (this) {
      case PestType.bunny:
        return 'Bunny';
      case PestType.snail:
        return 'Snail';
      case PestType.turtle:
        return 'Turtle';
    }
  }

  int get health {
    switch (this) {
      case PestType.bunny:
        return 154;
      case PestType.snail:
        return 126;
      case PestType.turtle:
        return 92;
    }
  }

  Vector2 get spriteSize {
    switch (this) {
      case PestType.bunny:
        return Vector2(34, 44);
      case PestType.snail:
        return Vector2(38, 24);
      case PestType.turtle:
        return Vector2(44, 26);
    }
  }
}
