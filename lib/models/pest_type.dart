import 'package:flame/components.dart';

enum PestType {
  bunny,
  slime,
  pig,
}

extension PestTypeExt on PestType {
  int get damage {
    switch (this) {
      case PestType.bunny:
        return 20;
      case PestType.slime:
        return 15;
      case PestType.pig:
        return 8;
    }
  }

  int get hitAnimationAmount {
    switch (this) {
      case PestType.bunny:
      case PestType.pig:
        return 5;
      case PestType.slime:
        return 5;
    }
  }

  int get runAnimationAmount {
    switch (this) {
      case PestType.bunny:
      case PestType.pig:
        return 12;
      case PestType.slime:
        return 10;
    }
  }

  int get dodgePercent {
    switch (this) {
      case PestType.bunny:
        return 36;
      case PestType.slime:
        return 24;
      case PestType.pig:
        return 12;
    }
  }

  String get title {
    switch (this) {
      case PestType.bunny:
        return 'Bunny';
      case PestType.slime:
        return 'Slime';
      case PestType.pig:
        return 'Pig';
    }
  }

  int get health {
    switch (this) {
      case PestType.bunny:
        return 154;
      case PestType.slime:
        return 126;
      case PestType.pig:
        return 92;
    }
  }

  Vector2 get spriteSize {
    switch (this) {
      case PestType.bunny:
        return Vector2(34, 44);
      case PestType.slime:
        return Vector2(44, 30);
      case PestType.pig:
        return Vector2(36, 30);
    }
  }
}
