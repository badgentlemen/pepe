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
import 'package:pepe/components/plant_card.dart';
import 'package:pepe/components/primary_sun.dart';
import 'package:pepe/components/solar_panel.dart';
import 'package:pepe/components/square.dart';
import 'package:pepe/components/sun.dart';
import 'package:pepe/components/time_progress_bar.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/plant_type.dart';

const double resolutionAspect = 2319 / 1307;

class P2PGame extends FlameGame with TapCallbacks, HasCollisionDetection, HasDraggablesBridge {
  /// Собранная сила солнца
  int sunPower = 100;

  /// Собранная сила ветра
  int windPower = 100;

  bool isSunBlocked = false;

  List<List<Square>> fieldSquares = [];

  List<Pest> pests = [];

  final int solarPanels = 3;

  double get blockSize => size.x / 22;

  late TextComponent powerLabel;

  Vector2 get generatorSize => Vector2(blockSize, blockSize * generatorAssetRatio);
  Vector2 get generatorPosition => Vector2(size.x - blockSize - generatorSize.x, powerSunPosition.y);

  Vector2 get powerSunSize => Vector2(blockSize * 1.4, blockSize * 1.4);
  Vector2 get powerSunPosition => Vector2(blockSize, 10);

  Vector2 get dashboardPosition => Vector2(blockSize * 3, 5);

  Vector2 get skyPosition => Vector2(dashboardPosition.x, blockSize * 2);

  Vector2 get primarySunPosition => Vector2(size.x - primarySunSize.x, skyPosition.y);
  Vector2 get primarySunSize => Vector2(blockSize * 2.2, blockSize * 2.2);

  Vector2 get solarPanelSize => Vector2(blockSize * 1.5, (blockSize * 1.5) / SolarPanel.aspectRatio);
  Vector2 get solarPanelPosition => Vector2(dashboardPosition.x, size.y - blockSize - solarPanelSize.y);

  double get cloudWidth => blockSize * 1.6;

  double get plantCardWidth => blockSize * 1.6;
  double get plantCardHeight => plantCardWidth / plantCardRatio;

  double get timingWidth => size.x / 4;

  Timer? _cloudTimer;

  bool isPaused = false;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  FutureOr<void> onLoad() async {
    try {
      await images.loadAllImages();
    } catch (e) {
      print(e);
    }

    _addSolars();
    _addField();
    _addPrimarySun();
    _handleClouds();
    _addPowerSun();
    _addPowerLabel();
    _addPlantCards();
    _addGenerator();

    add(TimeProgressBar(percentage: 90));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _cloudTimer?.update(dt);
    powerLabel.text = sunPower.toString();
    super.update(dt);
  }

  void _addGenerator() {
    add(SpriteComponent(sprite: Sprite(images.fromCache('generator.png'),), size: generatorSize,));
  }

  void _addPlantCards() {
    for (var i = 0; i < PlantType.values.length; i++) {
      final type = PlantType.values[i];

      add(
        PlantCard(
          position: Vector2(dashboardPosition.x + (plantCardWidth + 10) * i, dashboardPosition.y),
          type: type,
        ),
      );
    }
  }

  void _addSolars() {
    for (var i = 0; i < solarPanels; i++) {
      final next = Vector2(solarPanelPosition.x + (i * solarPanelSize.x), solarPanelPosition.y);

      add(
        SolarPanel(
          position: next,
          index: i + 1,
        ),
      );
    }
  }

  void _addField() {
    final field = Field();
    add(field);
  }

  void _addPowerSun() {
    final sun = Sun(
      position: powerSunPosition,
      size: powerSunSize,
      reversed: true,
    );

    add(sun);
  }

  void _handleClouds() {
    void sendCloud() {
      final cloud = Cloud();

      add(cloud);
    }

    _cloudTimer = Timer(
      cloudFrequency,
      onTick: () {
        final random = Random().nextDouble();

        if (random <= .2) {
          sendCloud();
        }
      },
      repeat: true,
    );

    sendCloud();
  }

  void _addPowerLabel() {
    powerLabel = Label(
      value: sunPower,
      size: Vector2(80, 20),
      position: Vector2(
        blockSize + 8,
        powerSunPosition.y + powerSunSize.y + 10,
      ),
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
