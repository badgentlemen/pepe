import 'package:pepe/constants.dart';
import 'package:pepe/models/random_range.dart';
import 'package:pepe/models/scripted_pest.dart';

class LevelScript {
  LevelScript({
    this.scriptedPests = const [],
    this.electricity = defaultElectricity,
    this.sunPower = defaultSunPower,
    this.timeDuration = defaultLevelDuration,
    this.cloundRandom = defaultCloudRandomRange,
  });

  final List<ScriptedPest> scriptedPests;

  final RandomRange cloundRandom;

  final int sunPower;

  final int electricity;

  final Duration timeDuration;
}
