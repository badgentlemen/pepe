import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:pepe/components/aiplane_card.dart';
import 'package:pepe/components/bolt.dart';
import 'package:pepe/components/cloud.dart';
import 'package:pepe/components/field.dart';
import 'package:pepe/components/label.dart';
import 'package:pepe/components/pest.dart';
import 'package:pepe/components/plant_card.dart';
import 'package:pepe/components/primary_sun.dart';
import 'package:pepe/components/solar_panel.dart';
import 'package:pepe/components/square.dart';
import 'package:pepe/components/sun.dart';
import 'package:pepe/components/wind_turbine.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/models/airplane_type.dart';
import 'package:pepe/models/level_script.dart';
import 'package:pepe/models/plant_type.dart';
import 'package:pepe/p2p_game.dart';

class Level extends RectangleComponent with HasGameRef<P2PGame> {
  Level({required this.script}) {
    sunPower = script.sunPower;
    electricity = script.electricity;
  }

  final LevelScript script;

  /// Собранная сила солнца
  int sunPower = 0;

  /// Собранная сила ветра
  int electricity = 0;

  bool isSunBlocked = false;

  List<List<Square>> fieldSquares = [];

  List<Pest> pests = [];

  Timer? _cloudTimer;

  late Label powerLabel;

  late Label electricityLabel;

  @override
  FutureOr<void> onLoad() {

    _addHill();
    _addSolars();
    _addField();
    _addPrimarySun();
    _handleClouds();
    _addPowerSun();
    _addPowerLabel();
    _addPlantCards();
    _addPlaneCards();
    _addGenerator();
    _addElectricityLabel();
    _addWindTurbines();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _cloudTimer?.update(dt);
    powerLabel.text = sunPower.toString();
    electricityLabel.text = electricity.toString();
    super.update(dt);
  }

  void _addHill() {
    add(SpriteComponent(
      sprite: Sprite(game.images.fromCache('hill.png')),
      position: Vector2(-2, game.size.y - 170),
      size: Vector2(game.size.x + 2, (game.size.x + 2) / fieldAssetRatio),
      priority: 0,
    ));
  }

  void _addGenerator() {
    add(
      SpriteComponent(
        sprite: Sprite(
          game.images.fromCache('generator.png'),
        ),
        size: game.generatorSize,
        position: game.generatorPosition,
      ),
    );
  }

  void _addPlantCards() {
    for (var i = 0; i < PlantType.values.length; i++) {
      final type = PlantType.values[i];

      add(
        PlantCard(
          position: Vector2(game.dashboardPosition.x + (game.cardsWidth + 10) * i, game.dashboardPosition.y),
          type: type,
        ),
      );
    }
  }

  void _addPlaneCards() {
    final y = game.dashboardPosition.y;

    add(
      AirplaneCard(
        type: AirplaneType.manure,
        position: Vector2(game.generatorPosition.x - game.cardsWidth - 10 - game.cardsWidth - 20, y),
      ),
    );

    add(
      AirplaneCard(
        type: AirplaneType.chemical,
        position: Vector2(game.generatorPosition.x - game.cardsWidth - 20, y),
      ),
    );
  }

  void _addSolars() {
    for (var i = 0; i < solarPanels; i++) {
      final next = Vector2(game.solarPanelPosition.x + (i * game.solarPanelSize.x), game.solarPanelPosition.y);

      add(
        SolarPanel(
          position: next,
          index: i + 1,
        ),
      );
    }
  }

  void _addWindTurbines() {
    for (var i = 0; i < windTurbines; i++) {
      final next = Vector2(game.windTurbinePosition.x + (i * (game.windTurbineSize.x + game.windTurbineSpace)), game.windTurbinePosition.y);

      add(
        WindTurbine(
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
      position: game.powerSunPosition,
      size: game.powerSunSize,
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

        if (random <= .3 || random >= .75) {
          sendCloud();
        }
      },
      repeat: true,
    );

    sendCloud();
  }

  void _addPowerLabel() {
    powerLabel = Label(
      text: sunPower.toString(),
      size: game.labelsSize,
      position: game.powerLabelPosition,
    );

    add(powerLabel);
  }

  void _addElectricityLabel() {
    electricityLabel = Label(
        text: electricity.toString(), color: electricityColor, size: game.labelsSize, position: game.electricityLabelPosition);

    add(electricityLabel);

    add(
      Bolt(
        w: 16,
        position: Vector2(
          game.electricityLabelPosition.x + game.labelsSize.x + 5,
          game.electricityLabelPosition.y + 2,
        ),
      ),
    );
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

  void increaseElectricity(int other) {
    electricity += other;
  }

  void reduceElectricity(int other) {
    if (electricity > 0) {
      electricity = max(0, electricity - other);
    }
  }

  void dispose() {
    removeFromParent();
  }
}
