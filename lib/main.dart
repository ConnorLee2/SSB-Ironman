import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';
import 'package:ssbu_ironman/pages/settings_page.dart';

import 'models/game_notifier.dart';
import 'models/home_notifier.dart';
import 'models/roster_model.dart';

import 'common/theme.dart';
import 'pages/home_page.dart';
import 'pages/character_page.dart';
import 'pages/game_page.dart';

/// flutter build apk --release
/// fluter install
Future<void> main() async {
  await Settings.init();
  runApp(SSBIronmanApp());
}

class SSBIronmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => RosterModel()),
        ChangeNotifierProxyProvider<RosterModel, HomeNotifier>(
          create: (context) => HomeNotifier(),
          update: (context, roster, game) {
            game.roster = roster;
            return game;
          },
        ),
        ChangeNotifierProvider(create: (context) => GameNotifier()),
      ],
      child: MaterialApp(
        title: 'SSB Ironman',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/characters': (context) => CharacterPage(),
          '/game': (context) => GamePage(),
          '/settings': (context) => SettingsPage(),
        },
      ),
    );
  }
}
