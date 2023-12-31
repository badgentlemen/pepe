import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/p2p_game.dart';


class FlameText extends TextComponent with HasGameRef<P2PGame> {
  FlameText({
    super.position,
    super.size,
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
    textRenderer = TextPaint(style: textStyle.copyWith(color: color));

    return super.onLoad();
  }
}
