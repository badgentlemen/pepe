import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pepe/p2p_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  const game = GameApp();

  runApp(game);
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantsVsPests',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: GameWidget(

          game: P2PGame(),
        ),
      ),
    );
  }
}
