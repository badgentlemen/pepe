import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/plants_vs_pests_game.dart';

class Hill extends SpriteComponent with HasGameRef<PlantsVsPestsGame> {
  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache('field.png'),
      srcPosition: Vector2(90, 200),
    );

    return super.onLoad();
  }
}
