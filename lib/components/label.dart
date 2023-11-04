import 'package:flame/components.dart';
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
  Future<void> onLoad() {
    textRenderer = TextPaint(
      style: TextStyle(
        fontWeight: FontWeight.w900,
        color: Colors.orange.shade400,
        fontSize: 16,
        height: 1,
      ),
    );

    return super.onLoad();
  }

  @override
  void drawBackground(Canvas c) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.orange.shade400);

    super.drawBackground(c);
  }
}
