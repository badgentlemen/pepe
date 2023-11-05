import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/components/flame_text.dart';
import 'package:pepe/components/sun.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/p2p_game.dart';
import 'package:pepe/utils.dart';

class PlantCard extends RectangleComponent with HasGameRef<P2PGame> {
  PlantCard({
    required this.type,
    required super.position,
  });

  final PlantType type;

  String get priceString => type.price.toString();

  int get countWeCanBuy => (game.sunPower / type.price).floor();

  String get countWeCanBuyString => countWeCanBuy.toString();

  double get payloadBlockHeight => height - infoFieldSize.y;

  double get avatarAspectWidth {
    switch (type) {
      case PlantType.carrot:
        return .65;
      case PlantType.corn:
        return .9;
      case PlantType.watermelon:
        return .7;
    }
  }

  Vector2 get avatarSize => type.aspectSize(width * avatarAspectWidth);

  TextStyle get countLabelTextStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        height: 1,
        color: Colors.black,
      );

  Size get countLabelTextSize => fetchTextSizeByStyle(countWeCanBuyString, countLabelTextStyle);

  Vector2 get countLabelPosition => Vector2(
        size.x - countLabelTextSize.width - 14,
        0,
      );

  Vector2 get infoFieldSize => Vector2(size.x, game.blockSize / 2.2);

  TextBoxComponent? countLabel;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(game.cardsWidth, game.cardsHeight);
    priority = 3;

    paintLayers = [
      Paint()..color = Colors.amber.shade50,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.black,
    ];

    _addInfoField();
    _addAvatar();
    _addCountLabel();
    _addPlantGrassCard();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    countLabel?.text = countWeCanBuyString;
    countLabel?.position = countLabelPosition;
    super.update(dt);
  }

  void _addInfoField() {
    final infoFieldPosition = Vector2(0, size.y - infoFieldSize.y);
    final priceTextSize = fetchTextSizeByStyle(priceString, FlameText.textStyle);
    final sunSize = Vector2(infoFieldSize.y, infoFieldSize.y);

    final infoField = RectangleComponent(
      position: infoFieldPosition,
      size: infoFieldSize,
      paintLayers: [
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.black,
      ],
    );

    final priceLabel = FlameText(
      position: Vector2(infoFieldSize.x / 2 - priceTextSize.width / 2 + sunSize.x / 2 + 5,
          infoFieldSize.y / 2 - priceTextSize.height / 2),
      color: sunPowerColor,
    )..text = priceString;

    infoField.add(priceLabel);

    infoField.add(
      Sun(
        position: Vector2(infoFieldSize.x / 2 - sunSize.x, infoFieldSize.y / 2 - sunSize.y / 2),
        size: sunSize,
        reversed: true,
      ),
    );

    add(infoField);
  }

  void _addCountLabel() {
    countLabel = TextBoxComponent(
      text: countWeCanBuyString,
      textRenderer: TextPaint(style: countLabelTextStyle),
      position: countLabelPosition,
      priority: 4,
    );

    add(countLabel!);
  }

  void _addAvatar() {
    add(
      SpriteComponent(
          sprite: type.fetchSprite(game.images),
          size: avatarSize,
          position: Vector2(
            width / 2 - avatarSize.x / 2,
            payloadBlockHeight / 2 - avatarSize.y / 2,
          )),
    );
  }

  void _addPlantGrassCard() {
    final grassCardSize = Vector2(24, 24);

    add(
      SpriteComponent(
        sprite: type.fetchGrassSprite(game.images),
        position: Vector2(
          size.x - grassCardSize.x,
          payloadBlockHeight - grassCardSize.y,
        ),
        size: grassCardSize,
      ),
    );
  }
}
