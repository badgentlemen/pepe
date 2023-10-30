import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pepe/field.dart';
import 'package:pepe/pest.dart';
import 'package:pepe/square.dart';
import 'package:pepe/sun.dart';

class PlantsVsPestsGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  /// Сила игрока
  int power = 100;

  /// Очки игрока
  int score = 0;

  List<List<Square>> fieldSquares = [];

  List<Pest> pests = [];

  final int fieldRows = 4;

  final int fieldColumns = 12;

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

    _addField();
    _addPrimarySun();

    return super.onLoad();
  }

  void _addField() {
    final field = Field(
      position: Vector2(100, 150),
      rows: fieldRows,
      columns: fieldColumns,
    );

    add(field);
  }

  void _addPrimarySun() {
    final sun = Sun(position: Vector2(20, 20), looksRight: true);
    add(sun);
  }
}
