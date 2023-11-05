import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:pepe/components/airplane.dart';
import 'package:pepe/components/bolt.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/airplane_type.dart';
import 'package:pepe/p2p_game.dart';
import 'package:pepe/utils.dart';

class AirplaneCard extends RectangleComponent with TapCallbacks,HasGameRef<P2PGame> {
  AirplaneCard({
    required this.type,
    super.position,
  });

  final AirplaneType type;

  double get _boltWidth => width / 8;

  double get _boltSpace => 3;

  TextStyle get _titleTextStyle => TextStyle(
        fontWeight: FontWeight.w900,
        color: type.color,
        fontSize: 14,
      );
  Size get _titleTextSize => fetchTextSizeByStyle(
        type.title,
        _titleTextStyle,
      );
  Vector2 get _titlePosition => Vector2(
        width / 2 - _titleTextSize.width / 2,
        _airplanePosition.x + _airplaneHeight + 8,
      );

  Size get _priceSize => fetchTextSizeByStyle(
        type.price.toString(),
        _titleTextStyle,
      );

  Vector2 get _pricePosition => Vector2(
        width / 2 - (_priceSize.width - _boltWidth + _boltSpace / 2),
        _titlePosition.y + _titleTextSize.height + 10,
      );

  double get _airplaneWidth => width * .7;
  double get _airplaneHeight => _airplaneWidth / airplaneAssetRatio;

  late Vector2 _airplanePosition;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(game.cardsWidth, game.cardsHeight);

    paintLayers = [
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.orange
        ..strokeWidth = 1,
    ];

    _addAiplane();
    _addTitle();
    _addPrice();

    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    _handleTapped();
  }

  _addAiplane() {
    final aiplane = Airplane(
      width: width * .7,
    );

    _airplanePosition = Vector2(
      width / 2 - aiplane.width / 2,
      height / 10,
    );

    aiplane.position = _airplanePosition;
    add(aiplane);
  }

  _addTitle() {
    final textComponent = TextComponent(
      text: type.title,
      textRenderer: TextPaint(style: _titleTextStyle),
      position: _titlePosition,
    );

    add(textComponent);
  }

  _addPrice() {
    final textComponent = TextComponent(
      text: type.price.toString(),
      textRenderer: TextPaint(
        style: _titleTextStyle.copyWith(
          color: electricityColor,
        ),
      ),
      position: _pricePosition,
    );

    final bolt = Bolt(
      w: _boltWidth,
      position: Vector2(
        _pricePosition.x + _priceSize.width + _boltSpace,
        _pricePosition.y + 2,
      ),
    );

    addAll([textComponent, bolt]);
  }

  void _handleTapped() {

  }
}
