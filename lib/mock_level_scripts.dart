import 'package:pepe/components/pest.dart';
import 'package:pepe/models/level_script.dart';
import 'package:pepe/models/pest_type.dart';
import 'package:pepe/models/scripted_pest.dart';

final firstLevelScript = LevelScript(
  sunPower: 300,
  electricity: 300,
  scriptedPests: [
    ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 1),
      row: 0,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.slime),
      delayDuration: const Duration(seconds: 20),
      row: 0,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.slime),
      delayDuration: const Duration(seconds: 40),
      row: 4,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 70),
      row: 4,
    ),
     ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 75),
      row: 0,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 80),
      row: 3,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.slime),
      delayDuration: const Duration(seconds: 120),
      row: 2,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.bunny),
      delayDuration: const Duration(seconds: 110),
      row: 0,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 100),
      row: 4,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.slime),
      delayDuration: const Duration(seconds: 105),
      row: 4,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.slime),
      delayDuration: const Duration(seconds: 170),
      row: 1,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.bunny),
      delayDuration: const Duration(seconds: 180),
      row: 3,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 200),
      row: 1,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 60),
      row: 0,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.slime),
      delayDuration: const Duration(seconds: 130),
      row: 3,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 140),
      row: 3,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.slime),
      delayDuration: const Duration(seconds: 200),
      row: 3,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 210),
      row: 4,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.bunny),
      delayDuration: const Duration(seconds: 215),
      row: 4,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.slime),
      delayDuration: const Duration(seconds: 200),
      row: 0,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 205),
      row: 0,
    ),
    ScriptedPest(
      pest: Pest(type: PestType.pig),
      delayDuration: const Duration(seconds: 140),
      row: 0,
    ),
  ],
);

final secondLevelScript = LevelScript(
    // scriptedPests: List.generate((defaultLevelDuration.inSeconds / 30).floor(), (index) => null)
    );
