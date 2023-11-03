import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/plants_vs_pests_game.dart';

class FlameText extends TextComponent with HasGameRef<PlantsVsPestsGame> {
  FlameText({
    required super.position,
    this.color = Colors.black,
  });

  final Color? color;

  static const textStyle = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 16,
    height: 1,
  );

  @override
  FutureOr<void> onLoad() {
    textRenderer = TextPaint(
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w900,
        fontSize: 16,
        height: 1,
      ).copyWith(color: color),
    );

    return super.onLoad();
  }
}
