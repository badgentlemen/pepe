import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/models/bg_tile_type.dart';
import 'package:pepe/p2p_game.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<P2PGame> {
  BackgroundTile({
    this.type = BackgroundTileType.blue,
    super.position,
  });

  final BackgroundTileType type;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(game.blockSize / 2, game.blockSize / 2);

    sprite = Sprite(
      game.images.fromCache(
        'Background/${type.title}.png',
      ),
    );
    return super.onLoad();
  }
}
