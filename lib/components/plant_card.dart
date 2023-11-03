import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pepe/components/flame_text.dart';
import 'package:pepe/components/sun.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/plants_vs_pests_game.dart';
import 'package:pepe/utils.dart';

class PlantCard extends RectangleComponent with HasGameRef<PlantsVsPestsGame> {
  PlantCard({
    required this.type,
    required super.position,
  });

  final PlantType type;

  String get costs => type.costs.toString();

  int get countWeCanBuy => (game.sunPower / type.costs).ceil();

  String get countWeCanBuyString => countWeCanBuy.toString();

  TextBoxComponent? countLabel;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(game.plantCardWidth, game.plantCardHeight);
    priority = 3;

    paintLayers = [
      Paint()..color = Colors.amber.shade50,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.black,
    ];

    _addInfoField();
    _addPicture();
    _addCountLabel();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    countLabel?.text = countWeCanBuyString;
    super.update(dt);
  }

  void _addInfoField() {
    final infoFieldSize = Vector2(size.x, game.blockSize / 2.2);
    final infoFieldPosition = Vector2(0, size.y - infoFieldSize.y);
    final costsTextSize = fetchTextSizeByStyle(costs, FlameText.textStyle);
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

    final costsLabel = FlameText(
      position: Vector2(infoFieldSize.x / 2 - costsTextSize.width / 2 + sunSize.x / 2 + 5,
          infoFieldSize.y / 2 - costsTextSize.height / 2),
      color: Colors.orange,
    )..text = costs;

    infoField.add(costsLabel);
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
    const textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      height: 1,
      color: Colors.black,
    );

    final textSize = fetchTextSizeByStyle(countWeCanBuyString, textStyle);
    countLabel = TextBoxComponent(
      text: countWeCanBuyString,
      textRenderer: TextPaint(style: textStyle),
      position: Vector2(
        size.x - textSize.width - 14,
        0,
      ),
      priority: 4,
    );

    add(countLabel!);
  }

  void _addPicture() {}
}
