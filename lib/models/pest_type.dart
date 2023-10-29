import 'package:flame/components.dart';
import 'package:pepe/models/pest_animation_type.dart';

enum PestType {
  bunny,
  snail,
  turtle,
}

extension PestTypeExt on PestType {
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
