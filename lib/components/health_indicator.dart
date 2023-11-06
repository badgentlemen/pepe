import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/p2p_game.dart';
import 'package:pepe/utils.dart';

class HealthIndicator extends RectangleComponent with HasGameRef<P2PGame> {
  HealthIndicator({
    required this.currentValue,
    required this.maxValue,
    super.position,
    super.size,
  });

  num currentValue;

  num maxValue;

  int get _percentage => ((currentValue * 100) / maxValue).floor();

  double get _strokeWidth => 1;

  Vector2 get _indicatorSize => Vector2(size.x * (_percentage / 100), size.y - _strokeWidth);

  Color get _indicatorColor => _percentage <= 30
      ? Colors.red
      : _percentage <= 50
          ? Colors.orange
          : Colors.green;

  final textStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 15,
  );

  String get _text => currentValue.toDouble().toStringAsFixed(0);

  Size get textSize => fetchTextSizeByStyle(_text, textStyle);

  Vector2 get textPosition => Vector2(
        width / 2 - textSize.width / 2,
        height / 2 - textSize.height / 2,
      );

  late TextComponent _textComponent;
  late RectangleComponent _indicatorComponent;

  @override
  FutureOr<void> onLoad() {

    priority = 100;

    _addIndicator();
    _addTextComponent();

    paintLayers = [
      Paint()..color = Colors.white,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black
        ..strokeWidth = _strokeWidth,
    ];

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateIndicatorColor();
    _textComponent.text = _text;
    _textComponent.position = textPosition;
    _indicatorComponent.size = _indicatorSize;
    super.update(dt);
  }

  void setMax(num value) => maxValue = value;

  void setValue(num val) => currentValue = val;

  void updateData({required num max, required num value}) {
    setMax(max);
    setValue(value);
  }

  void _updateIndicatorColor() => _indicatorComponent.paintLayers = [
        Paint()..color = _indicatorColor,
      ];

  void _addIndicator() {
    _indicatorComponent = RectangleComponent(
      size: _indicatorSize,
      position: Vector2(_strokeWidth - 1, _strokeWidth - 1),
    );

    add(_indicatorComponent);
  }

  void _addTextComponent() {
    _textComponent = TextComponent(
      position: textPosition,
      size: size,
      text: _text,
      // anchor: Anchor.center,
      textRenderer: TextPaint(style: textStyle),
    );

    add(_textComponent);
  }
}
