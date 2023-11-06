import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/components/background_tile.dart';
import 'package:pepe/models/bg_tile_type.dart';
import 'package:pepe/p2p_game.dart';

class Background extends RectangleComponent with HasGameRef<P2PGame> {
  Background({
    this.tileType = BackgroundTileType.yellow,
    this.faded = .35,
  });

  final BackgroundTileType tileType;

  final double faded;

  @override
  FutureOr<void> onLoad() {
    final tileSize = game.blockSize / 2;

    final rows = (game.size.y / tileSize).floor() + 1;
    final columns = (game.size.x / tileSize).floor() + 1;

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        final nextY = i * tileSize;
        final nextX = j * tileSize;

        add(
          BackgroundTile(
            position: Vector2(nextX, nextY),
            type: tileType,
          )..opacity = faded,
        );
      }
    }

    return super.onLoad();
  }
}
