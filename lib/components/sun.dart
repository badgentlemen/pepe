import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/plants_vs_pests_game.dart';

class Sun extends SpriteComponent with HasGameRef<PlantsVsPestsGame> {
  Sun({
    required super.position,
    this.reversed = false,
  }) : super(size: defaultSize);

  static Vector2 defaultSize = Vector2(
    70,
    70,
  );

  final bool reversed;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('sun.png'));

    if (reversed) {
      flipHorizontallyAroundCenter();
    }

    return super.onLoad();
  }
}
