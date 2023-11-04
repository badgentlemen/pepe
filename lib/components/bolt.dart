import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/p2p_game.dart';

class Bolt extends SpriteComponent with HasGameRef<P2PGame> {
  Bolt({required this.w, super.position,});

  final double w;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(w, w * boltAssetRatio);
    sprite = Sprite(game.images.fromCache('bolt.png'));

    return super.onLoad();
  }
}