import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/plants_vs_pests_game.dart';

class Sun extends SpriteComponent with HasGameRef<PlantsVsPestsGame> {
  Sun({
    required super.position,
    this.looksRight = false,
  }) : super(
          size: Vector2(
            70,
            70,
          ),
        );

  final bool looksRight;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('sun.png'));

    if (looksRight) {
      flipHorizontallyAroundCenter();
    }

    return super.onLoad();
  }
}
