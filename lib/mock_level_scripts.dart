import 'package:pepe/models/bg_tile_type.dart';
import 'package:pepe/models/level_setting.dart';
import 'package:pepe/models/pest_type.dart';
import 'package:pepe/models/scripted_pest.dart';

final firstLevelSetting = LevelSetting(
  sunPower: 500,
  electricity: 500,
  tileType: BackgroundTileType.yellow,
  scriptedPests: [
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 1),
      row: 0,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 5),
      row: 0,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 15),
      row: 4,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 30),
      row: 4,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 40),
      row: 0,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 45),
      row: 3,
    ),
  ],
);

final secondLevelSetting = LevelSetting(
  sunPower: 300,
  electricity: 300,
  scriptedPests: [
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 1),
      row: 0,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 20),
      row: 0,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 40),
      row: 4,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 70),
      row: 4,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 75),
      row: 0,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 80),
      row: 3,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 120),
      row: 2,
    ),
    ScriptedPest(
      type: PestType.bunny,
      onTime: const Duration(seconds: 110),
      row: 0,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 100),
      row: 4,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 140),
      row: 5,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 115),
      row: 6,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 105),
      row: 4,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 170),
      row: 1,
    ),
    ScriptedPest(
      type: PestType.bunny,
      onTime: const Duration(seconds: 180),
      row: 3,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 200),
      row: 1,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 60),
      row: 0,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 130),
      row: 3,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 140),
      row: 3,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 200),
      row: 3,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 210),
      row: 4,
    ),
    ScriptedPest(
      type: PestType.bunny,
      onTime: const Duration(seconds: 215),
      row: 4,
    ),
    ScriptedPest(
      type: PestType.slime,
      onTime: const Duration(seconds: 200),
      row: 0,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 205),
      row: 0,
    ),
    ScriptedPest(
      type: PestType.pig,
      onTime: const Duration(seconds: 140),
      row: 0,
    ),
  ],
);
