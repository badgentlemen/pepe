import 'package:pepe/constants.dart';
import 'package:pepe/models/bg_tile_type.dart';
import 'package:pepe/models/random_range.dart';
import 'package:pepe/models/scripted_pest.dart';

class LevelSetting {
  LevelSetting({
    this.scriptedPests = const [],
    this.electricity = defaultElectricity,
    this.sunPower = defaultSunPower,
    this.timeDuration = defaultLevelDuration,
    this.cloundRandom = defaultCloudRandomRange,
    this.tileType = BackgroundTileType.blue,
  });

  final List<ScriptedPest> scriptedPests;

  final BackgroundTileType tileType;

  final RandomRange cloundRandom;

  final int sunPower;

  final int electricity;

  final Duration timeDuration;
}
