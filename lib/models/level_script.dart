import 'package:pepe/constants.dart';
import 'package:pepe/models/scripted_pest.dart';

class LevelScript {
  LevelScript({
    this.scriptedPests = const [],
    this.electricity = defaultElectricity,
    this.sunPower = defaultSunPower,
    this.timeDuration = defaultLevelDuration,
  });

  final List<ScriptedPest> scriptedPests;

  final int sunPower;

  final int electricity;

  final Duration timeDuration;
}
