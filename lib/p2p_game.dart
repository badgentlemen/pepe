import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:pepe/components/level.dart';
import 'package:pepe/components/solar_panel.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/mock_level_scripts.dart';

class P2PGame extends FlameGame with TapCallbacks, HasCollisionDetection, HasDraggablesBridge {
  double get blockSize => size.x / blockSizeImpl;

  double get fenceWidth => blockSize * .5;
  double get fenceHeight => fenceWidth * .9;

  Vector2 get generatorSize => Vector2(blockSize, blockSize * generatorAssetRatio);
  Vector2 get generatorPosition => Vector2(size.x - blockSize - generatorSize.x, powerSunPosition.y);

  Vector2 get fieldSize => Vector2(fieldColumns * blockSize, fieldRows * blockSize);
  Vector2 get fieldPosition => Vector2(dashboardPosition.x, size.y - (blockSize * 2.2) - fieldSize.y);

  Vector2 get labelsSize => Vector2(60, 20);

  Vector2 get powerLabelPosition =>
      Vector2(dashboardPosition.x / 2 - labelsSize.x / 2, powerSunPosition.y + powerSunSize.y + 10);

  Vector2 get electricityLabelPosition => Vector2(generatorPosition.x, generatorPosition.y + generatorSize.x + 5);

  Vector2 get powerSunSize => Vector2(blockSize * 1.4, blockSize * 1.4);
  Vector2 get powerSunPosition => Vector2(dashboardPosition.x / 2 - powerSunSize.x / 2, 10);

  Vector2 get dashboardPosition => Vector2(blockSize * 2.7, 5);

  Vector2 get skyPosition => Vector2(dashboardPosition.x, blockSize * 2);

  Vector2 get primarySunPosition => Vector2(size.x - primarySunSize.x - blockSize, skyPosition.y);
  Vector2 get primarySunSize => Vector2(blockSize * 2.2, blockSize * 2.2);

  Vector2 get solarPanelSize => Vector2(blockSize * 1.5, (blockSize * 1.5) / SolarPanel.aspectRatio);
  Vector2 get solarPanelPosition => Vector2(dashboardPosition.x, size.y - blockSize - solarPanelSize.y);

  double get windTurbineHeight => blockSize * 1.2;
  double get windTurbineSpace => blockSize * .5;
  Vector2 get windTurbineSize => Vector2(windTurbineHeight * windTurbineAssetRatio, windTurbineHeight);
  Vector2 get windTurbinePosition => Vector2(size.x * .48, solarPanelPosition.y);

  double get cloudWidth => blockSize * 1.6;

  double get cardsWidth => blockSize * 1.6;
  double get cardsHeight => cardsWidth / cardsRatio;

  double get timingWidth => size.x / 4;

  bool get hasNext => _nextLevel != null;

  List<Level> _presetLevels = [];

  String? loadImagesError;

  Level? level;

  int _index = 0;

  Level? get _nextLevel {
    try {
      return _presetLevels[_index + 1];
    } catch (e) {
      return null;
    }
  }

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  FutureOr<void> onLoad() async {
    try {
      await images.loadAllImages();
    } catch (e) {
      loadImagesError = e.toString();
    }

    _presetLevels = [
      Level(script: firstLevelSetting),
      Level(script: secondLevelSetting),
    ];

    _runLevelAt(0);

    return super.onLoad();
  }

  void runNextLevel() {
    if (_nextLevel != null) {
      _runLevelAt(_index + 1);
    }
  }

  void openMenu() {
    for (var level in _presetLevels) {
      level.removeFromParent();
    }

    _index = 0;
  }

  void _runLevelAt(int index) {
    level?.removeFromParent();

    try {
      level = _presetLevels[index];
      _index = index;
      add(level!);
    } catch (e) {
      openMenu();
    }
  }
}
