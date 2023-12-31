import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:pepe/components/airplane_sprite.dart';
import 'package:pepe/components/bolt.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/airplane_type.dart';
import 'package:pepe/p2p_game.dart';
import 'package:pepe/utils.dart';

class AirplaneCard extends RectangleComponent with TapCallbacks, HasGameRef<P2PGame> {
  AirplaneCard({
    required this.type,
    super.position,
  });

  final AirplaneType type;

  double get _boltWidth => width / 8;

  double get _boltSpace => 3;

  bool get canSend => game.level?.canSendPlane(type) ?? false;

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

    _addAiplane();
    _addTitle();
    _addPrice();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    paintLayers = [
      Paint()
        ..style = PaintingStyle.stroke
        ..color = canSend ? Colors.blue : Colors.orange
        ..strokeWidth = 2,
    ];
    super.update(dt);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _handleTapped();
  }

  _addAiplane() {
    final aiplane = AirplaneSprite(
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

  Future<void> _handleTapped() async {
    if (isMounted) {
      if (game.level == null) {
        return;
      }

      if (game.level!.isCompleted) {
        return;
      }

      if (canSend) {
        final result = await FlutterPlatformAlert.showAlert(
          windowTitle: 'Отправить самолет с "${type.title}"',
          text: '',
          alertStyle: AlertButtonStyle.okCancel,
        );

        if (result == AlertButton.okButton) {
          game.level?.sendPlane(type);
        }
      } else {
        await FlutterPlatformAlert.showAlert(
          windowTitle: 'Недостаточно средств',
          text: 'Для отправки самолета "${type.title}" нужно ${type.price} энергии',
        );
      }
    }
  }
}
