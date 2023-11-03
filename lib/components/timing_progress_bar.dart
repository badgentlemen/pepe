import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/plants_vs_pests_game.dart';

class TimeProgressBar extends ShapeComponent with HasGameRef<PlantsVsPestsGame> {
  TimeProgressBar({int percentage = 0})
      : percentage = percentage > 100
            ? 100
            : percentage < 0
                ? 0
                : percentage;

  int percentage;

  @override
  Future<void> onLoad() async {
    debugMode = true;

    size = Vector2(game.timingWidth, game.blockSize / 5);
    position = Vector2(game.size.x - game.timingWidth - game.blockSize * .8, game.size.y - (game.blockSize * 1.7));

    paintLayers = [
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.red
        ..strokeWidth = 2,
    ];

    add(
      RectangleComponent(
        paintLayers: [Paint()..color = Colors.red],
        size: Vector2(size.x * (percentage / 100), size.y),
      ),
    );

    return super.onLoad();
  }
}
