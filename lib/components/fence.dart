import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/p2p_game.dart';

class Fence extends SpriteComponent with HasGameRef<P2PGame> {
  Fence({super.position, super.angle});

  int get _x => 21;

  int get _y => 13;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;

    size = Vector2(game.fenceWidth, game.fenceWidth * .9);

    sprite = Sprite(
      game.images.fromCache('grass.png'),
      srcPosition: Vector2(16.0 * _x, 16.0 * _y),
      srcSize: Vector2(22.0, 16.0,),
    );

    return super.onLoad();
  }
}
