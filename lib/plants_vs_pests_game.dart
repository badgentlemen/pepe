import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pepe/components/field.dart';
import 'package:pepe/components/hill.dart';
import 'package:pepe/components/label.dart';
import 'package:pepe/components/pest.dart';
import 'package:pepe/components/square.dart';
import 'package:pepe/components/sun.dart';

class PlantsVsPestsGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  /// Сила игрока
  int power = 200;

  /// Очки игрока
  int score = 0;

  List<List<Square>> fieldSquares = [];

  List<Pest> pests = [];

  final int fieldRows = 4;

  final int fieldColumns = 12;

  late TextComponent powerLabel;

  @override
  Color backgroundColor() {
    return Colors.grey.shade300;
  }

  @override
  FutureOr<void> onLoad() async {
    try {
      await images.loadAllImages();
    } catch (e) {
      print(e);
    }

    add(
      TextComponent(
        text: 'ИГРОВОЕ ПОЛЕ',
        position: Vector2(5, 5),
      ),
    );

    // _addHill();
    _addField();
    _addPrimarySun();
    _addPowerLabel();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    powerLabel.text = power.toString();
    super.update(dt);
  }

  void _addHill() {
    add(Hill());
  }

  void _addField() {
    final field = Field(
      position: Vector2(100, 100),
      rows: fieldRows,
      columns: fieldColumns,
    );

    add(field);
  }

  void _addPrimarySun() {
    final sun = Sun(position: Vector2(20, 30), looksRight: true);
    add(sun);
  }

  void _addPowerLabel() {
    powerLabel = Label(
      value: power,
      size: Vector2(80, 20),
      position: Vector2(15, 100),
    );

    add(powerLabel);
  }
}
