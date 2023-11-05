import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/p2p_game.dart';



class Airplane extends SpriteComponent with HasGameRef<P2PGame> {
  Airplane({super.position, required double width})
      : super(
          size: Vector2(width, width / airplaneAssetRatio),
        );

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('plane.png'));
    return super.onLoad();
  }
}
