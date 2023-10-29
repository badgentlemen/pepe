import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pepe/field.dart';
import 'package:pepe/label.dart';
import 'package:pepe/square.dart';
import 'package:pepe/sun.dart';

class PlantsVsPestsGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  int sunPower = 100;

  int score = 0;

  List<List<Square>> squares = [];

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



    final field = Field(
      position: Vector2(100, 40),
      rows: 5,
      columns: 10,
    );
    final sun = Sun(position: Vector2(20, 20));
    final scoreDash = Label(
      size: Vector2(56, 20),
      position: Vector2(26, 100),
      value: score,
    );

    add(field);
    add(sun);
    add(scoreDash);

    return super.onLoad();
  }
}
