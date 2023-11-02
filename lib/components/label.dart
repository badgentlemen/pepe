import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Label extends TextBoxComponent {
  Label({
    super.position,
    super.size,
    required this.value,
  }) : super(
          align: Anchor.center,
          boxConfig: TextBoxConfig(margins: const EdgeInsets.all(4)),
        );

  final int value;

  @override
  void drawBackground(Canvas c) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.black);

    super.drawBackground(c);
  }
}
