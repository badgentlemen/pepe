import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/p2p_game.dart';

const double _aspectRatio = 407 / 267;

class Airplane extends SpriteComponent with HasGameRef<P2PGame> {
  Airplane({super.position, required double width})
      : super(
          size: Vector2(width, width / _aspectRatio),
        );

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    sprite = Sprite(game.images.fromCache('plane.png'));
    return super.onLoad();
  }
}
