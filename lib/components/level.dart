import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:pepe/components/aiplane_card.dart';
import 'package:pepe/components/airplane.dart';
import 'package:pepe/components/background.dart';
import 'package:pepe/components/bolt.dart';
import 'package:pepe/components/cloud.dart';
import 'package:pepe/components/field.dart';
import 'package:pepe/components/label.dart';
import 'package:pepe/components/pest.dart';
import 'package:pepe/components/plant.dart';
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
import 'package:pepe/utils.dart';
import 'package:uuid/uuid.dart';

class Level extends RectangleComponent with HasGameRef<P2PGame> {
  Level({
    required this.script,
  }) : id = 'level-${const Uuid().v4()}' {
    sunPower = script.sunPower;
    electricity = script.electricity;
  }

  /// Идентификатор уровня
  final String id;

  /// Скрипт уровня
  final LevelScript script;

  /// Собранная сила солнца
  int sunPower = 0;

  /// Собранная сила ветра
  int electricity = 0;

  /// Солнце затянуто облаками
  bool isSunBlocked = false;

  /// Список полей на игральной доске
  List<List<Square>> fieldSquares = [];

  /// Список вредителей на игральной доске
  List<Pest> pests = [];

  /// Список посаженных растений
  List<Plant> plants = [];

  /// Количество убитый вредителей на уровне
  int killedPests = 0;

  /// Один или несколько вредителей дошли до границы поля
  bool pestReachedBorder = false;

  /// Таймер для отправки облаков по небу
  Timer? _cloudTimer;

  int get sciptedPestCount => script.scriptedPests.length;

  /// Оставшееся время до окончания
  Duration get timeLeft => endDateTime.difference(DateTime.now());

  /// Отформатированное оставшееся время до конца игры
  String get formattedTimeLeft => timeLeft.minuteAndSeconds();

  /// Размер отформатированного оставшеегося время
  Size get formattedTimeLeftSize => fetchTextSizeByStyle(formattedTimeLeft, remainingTextStyle);

  /// Стиль отформатированного оставшеегося время
  TextStyle get remainingTextStyle => const TextStyle(
        fontWeight: FontWeight.w900,
        color: Colors.black,
        fontSize: 30,
        height: 1,
      );

  String get killedPestsRemaining => '$killedPests / $sciptedPestCount';

  Size get killedPestsRemainingSize => fetchTextSizeByStyle(killedPestsRemaining, remainingTextStyle);

  /// Секунды пройденные с начала игры
  int get completedDurationSec => DateTime.now().difference(startedDateTime).inSeconds;

  /// Все противники (вредители) уничтожены
  bool get allEnemiesDead => killedPests >= sciptedPestCount;

  /// Уровень успешно пройден
  bool get isWin => allEnemiesDead && !pestReachedBorder;

  /// Уровень окончен
  bool get isCompleted => true; //allEnemiesDead || pestReachedBorder;

  late Label powerLabel;

  late Label electricityLabel;

  late TextComponent pestsKilledRemainingLabel;

  late DateTime startedDateTime;

  late DateTime endDateTime;

  @override
  FutureOr<void> onLoad() {
    startedDateTime = DateTime.now();
    endDateTime = startedDateTime.add(script.timeDuration);

    pestsKilledRemainingLabel = TextComponent(
      textRenderer: TextPaint(style: remainingTextStyle),
      priority: 4,
    );

    add(pestsKilledRemainingLabel);

    try {
      add(
        Background(
          tileType: script.tileType,
        ),
      );

      /// Можно потом вернуть
      // _addHill();
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
    } catch (e) {
      print(e);
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!isCompleted) {
      _cloudTimer?.update(dt);
    }

    powerLabel.text = sunPower.toString();
    electricityLabel.text = electricity.toString();
    _updateKilledPestsRemainingLabel();

    super.update(dt);
  }

  /// ADD COMPONENTS
  // void _addHill() {
  //   add(SpriteComponent(
  //     sprite: Sprite(game.images.fromCache('hill.png')),
  //     position: Vector2(-2, game.size.y - 170),
  //     size: Vector2(game.size.x + 2, (game.size.x + 2) / fieldAssetRatio),
  //     priority: 0,
  //   ));
  // }

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
      final next = Vector2(game.windTurbinePosition.x + (i * (game.windTurbineSize.x + game.windTurbineSpace)),
          game.windTurbinePosition.y);

      add(
        WindTurbine(
          position: next,
          index: i + 1,
        ),
      );
    }
  }

  void _addField() {
    final field = Field(
      sciptedPests: [...script.scriptedPests],
    );
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
    _cloudTimer = Timer(
      cloudFrequency,
      onTick: () {
        if (isCompleted) {
          return;
        }

        final random = Random().nextDouble();

        if (random <= script.cloundRandom.less || random >= script.cloundRandom.over) {
          final cloud = Cloud();

          add(cloud);
        }
      },
      repeat: true,
    );
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
        text: electricity.toString(),
        color: electricityColor,
        size: game.labelsSize,
        position: game.electricityLabelPosition);

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

  void _addPrimarySun() => add(PrimarySun());

  /// LOGIC METHODS
  bool canSendPlane(AirplaneType type) {
    if (isCompleted) {
      return false;
    }

    return electricity >= type.price;
  }

  void _updateKilledPestsRemainingLabel() {
    pestsKilledRemainingLabel.text = killedPestsRemaining;
    pestsKilledRemainingLabel.size = Vector2(killedPestsRemainingSize.width, killedPestsRemainingSize.height);
    pestsKilledRemainingLabel.position = Vector2(game.size.x / 2 - pestsKilledRemainingLabel.width / 2, 10);
  }

  Future<void> _checkGameCompleted() async {
    if (!isCompleted) {
      return;
    }

    if (isWin) {
      final result = await FlutterPlatformAlert.showAlert(
        windowTitle: 'ВЫ ВЫИГРАЛИ',
        text: 'Вы сумели защитить поле от вредителей. Продолжаем дальше?',
        alertStyle: AlertButtonStyle.okCancel,
      );

      /// TODO: обработка перехода на следующий уровень
      if (result == AlertButton.okButton) {}
      {}
    } else {
      FlutterPlatformAlert.showAlert(
        windowTitle: 'ВЫ ПРОИГРАЛИ',
        text: 'Один или несколько вредителей прошли поле',
      );
    }
  }

  void onPestKill(Pest pest) {
    if (isCompleted) {
      return;
    }

    killedPests += 1;
    increaseSunPower(pest.reward);
    pests.removeWhere((element) => element.id == pest.id);

    _checkGameCompleted();
  }

  void onPestReachBorder(Pest pest) {
    if (!pestReachedBorder) {
      pestReachedBorder = true;
      _checkGameCompleted();
    }
  }

  void onPestAdd(Pest pest) {
    if (isCompleted) {
      return;
    }

    pests.add(pest);
  }

  void onPlantAdd(Plant plant) {
    if (isCompleted) {
      return;
    }

    reduceSunPower(plant.price);
    plants.add(plant);
  }

  void sendPlane(AirplaneType type) {
    if (isCompleted) {
      return;
    }

    if (!canSendPlane(type)) {
      return;
    }

    final airplane = Airplane(
      type: type,
      width: game.blockSize * 1.4,
    );

    add(airplane);

    switch (type) {
      case AirplaneType.chemical:
        _applyChemicals();
        break;
      case AirplaneType.manure:
        _applyManure();
        break;
    }
  }

  Future<void> _applyChemicals() async {
    if (isCompleted) {
      return;
    }

    if (!canSendPlane(AirplaneType.chemical)) {
      return;
    }

    /// some delay before apply
    await Future.delayed(const Duration(milliseconds: 1200));

    reduceElectricity(AirplaneType.chemical.price);

    for (var pest in pests) {
      pest.handleChemicalDamage();
    }
  }

  Future<void> _applyManure() async {
    if (isCompleted) {
      return;
    }

    if (!canSendPlane(AirplaneType.manure)) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 1200));

    reduceElectricity(AirplaneType.chemical.price);

    for (var plant in plants) {
      plant.buff();
    }
  }

  void increaseSunPower(int other) {
    if (isCompleted) {
      return;
    }

    sunPower += other;
  }

  void reduceSunPower(int other) {
    if (isCompleted) {
      return;
    }

    if (sunPower > 0) {
      sunPower = max(0, sunPower - other);
    }
  }

  void increaseElectricity(int other) {
    if (isCompleted) {
      return;
    }

    electricity += other;
  }

  void reduceElectricity(int other) {
    if (isCompleted) {
      return;
    }

    if (electricity > 0) {
      electricity = max(0, electricity - other);
    }
  }

  void dispose() {
    removeFromParent();
  }
}
