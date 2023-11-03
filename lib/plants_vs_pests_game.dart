import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:pepe/components/cloud.dart';
import 'package:pepe/components/field.dart';
import 'package:pepe/components/label.dart';
import 'package:pepe/components/pest.dart';
import 'package:pepe/components/primary_sun.dart';
import 'package:pepe/components/solar_panel.dart';
import 'package:pepe/components/square.dart';
import 'package:pepe/components/sun.dart';
import 'package:pepe/constants.dart';

class PlantsVsPestsGame extends FlameGame with TapCallbacks, HasCollisionDetection, HasDraggablesBridge {
  /// Собранная сила солнца
  int sunPower = 1000;

  /// Собранная сила ветра
  int windPower = 1000;

  bool primarySunBlocked = false;

  List<List<Square>> fieldSquares = [];

  List<Pest> pests = [];

  final int fieldRows = 4;

  final int fieldColumns = 12;

  late TextComponent powerLabel;

  Vector2 get primarySunPosition => Vector2(size.x * .7, 10);

  Timer? _cloudTimer;

  @override
  Color backgroundColor() => Colors.black;

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

    _addSolars();
    _addField();
    _addPrimarySun();
    _handleClouds();
    _addPowerSun();
    _addPowerLabel();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _cloudTimer?.update(dt);
    powerLabel.text = sunPower.toString();
    super.update(dt);
  }

  void _addSolars() {
    for (var i = 0; i < 4; i++) {
      final next = Vector2(100 + (i * SolarPanel.defaultSize.x), 360);

      add(
        SolarPanel(
          position: next,
          index: i + 1,
        ),
      );
    }
  }

  void _addField() {
    final field = Field(
      position: Vector2(100, 100),
      rows: fieldRows,
      columns: fieldColumns,
    );

    add(field);
  }

  void _addPowerSun() {
    final sun = Sun(
      position: Vector2(20, 30),
      reversed: true,
    );

    add(sun);
  }

  void _handleClouds() {
    _cloudTimer = Timer(
      cloudFrequency,
      onTick: () {
        final random = Random().nextDouble();

        if (random <= 0.2 || random >= 0.8) {
          final cloud = Cloud(
              position: Vector2(
                20,
                10,
              ),
              reversed: random <= .2);

          add(cloud);
        }
      },
      repeat: true,
    );
  }

  void _addPowerLabel() {
    powerLabel = Label(
      value: sunPower,
      size: Vector2(80, 20),
      position: Vector2(15, 100),
    );

    add(powerLabel);
  }

  void _addPrimarySun() {
    add(PrimarySun());
  }

  void onPestKill(Pest pest) {
    increaseSunPower(pest.value);
    pests.removeWhere((pest) => pest.id == pest.id);
  }

  void increaseSunPower(int other) {
    sunPower += other;
  }

  void reduceSunPower(int other) {
    if (sunPower > 0) {
      sunPower = max(0, sunPower - other);
    }
  }

  void increaseWindPower(int other) {
    windPower += other;
  }

  void reduceWindPower(int other) {
    if (windPower > 0) {
      windPower = max(0, windPower - other);
    }
  }
}
