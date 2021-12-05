import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';
import 'package:ssbu_ironman/models/fighter.dart';
import 'package:ssbu_ironman/models/home_notifier.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.pop(context, "From Settings");
              var homeNotifier =
                  Provider.of<HomeNotifier>(context, listen: false);
              homeNotifier.getMaxCharacterCount();
            }),
        backgroundColor: Colors.green,
        title: Text('Ironman'),
      ),
      body: ListView(
        children: [
          SettingsGroup(
            title: 'Ironman',
            children: <Widget>[
              SliderSettingsTile(
                title: 'Stock Count',
                settingKey: 'key-stock-count',
                defaultValue: 3,
                min: 1,
                max: 8,
                step: 1,
                leading: Image(
                  height: 32,
                  width: 32,
                  image: Svg('assets/background/SmashBrosSymbol.svg'),
                  color: Colors.white,
                ),
                onChange: (value) {
                  debugPrint('key-stock-count: $value');
                },
              ),
              SliderSettingsTile(
                title: 'Roster count',
                settingKey: 'key-roster-count',
                defaultValue: 12,
                min: 1,
                max: 85,
                step: 1,
                leading: Image(
                  height: 32,
                  width: 32,
                  image: Svg('assets/background/SmashBrosSymbol.svg'),
                  color: Colors.white,
                ),
                onChange: (value) {
                  debugPrint('key-roster-count: $value');
                },
              ),
            ],
          ),
          SettingsGroup(
            title: 'DLC',
            children: <Widget>[
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-sf-plant',
                leading: Image.asset(
                  'assets/characters/piranha_plant.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Piranha Plant',
                onChange: (value) {
                  var fighter = Fighter(74, 'Piranha Plant', 'Mario');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp1-joker',
                leading: Image.asset(
                  'assets/characters/joker.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Joker',
                onChange: (value) {
                  var fighter = Fighter(75, 'Joker', 'Persona');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp1-hero',
                leading: Image.asset(
                  'assets/characters/hero.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Hero',
                onChange: (value) {
                  var fighter = Fighter(76, 'Hero', 'Dragon Quest');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp1-bk',
                leading: Image.asset(
                  'assets/characters/banjo_kazooie.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Banjo & Kazooie',
                onChange: (value) {
                  var fighter = Fighter(77, 'Banjo & Kazooie', 'Banjo Kazooie');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp1-terry',
                leading: Image.asset(
                  'assets/characters/terry.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Terry',
                onChange: (value) {
                  var fighter = Fighter(78, 'Terry', 'Fatal Fury');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp1-byleth',
                leading: Image.asset(
                  'assets/characters/byleth.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Byleth',
                onChange: (value) {
                  var fighter = Fighter(79, 'Byleth', 'Fire Emblem');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp2-minmin',
                leading: Image.asset(
                  'assets/characters/min_min.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Min Min',
                onChange: (value) {
                  var fighter = Fighter(80, 'Min Min', 'ARMS');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp2-steve',
                leading: Image.asset(
                  'assets/characters/steve.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Steve',
                onChange: (value) {
                  var fighter = Fighter(81, 'Steve', 'Minecraft');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp2-sephiroth',
                leading: Image.asset(
                  'assets/characters/sephiroth.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Sephiroth',
                onChange: (value) {
                  var fighter = Fighter(82, 'Sephiroth', 'Final Fantasy');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp2-pyra',
                leading: Image.asset(
                  'assets/characters/pyra.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Pyra',
                onChange: (value) {
                  var fighter = Fighter(83, 'Pyra', 'Xenoblade');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp2-kazuya',
                leading: Image.asset(
                  'assets/characters/kazuya.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Kazuya',
                onChange: (value) {
                  var fighter = Fighter(84, 'Kazuya', 'Tekken');
                  enableDisableFighter(fighter, value);
                },
              ),
              CheckboxSettingsTile(
                defaultValue: true,
                settingKey: 'key-roster-fp2-sora',
                leading: Image.asset(
                  'assets/characters/sora.png',
                  height: 32,
                  width: 32,
                ),
                title: 'Sora',
                onChange: (value) {
                  var fighter = Fighter(85, 'Sora', 'Kingdom Hearts');
                  enableDisableFighter(fighter, value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void enableDisableFighter(Fighter fighter, bool isEnabled) {
    var homeNotifier = Provider.of<HomeNotifier>(context, listen: false);
    if (isEnabled) {
      homeNotifier.roster.fighters.add(fighter);
    } else {
      homeNotifier.roster.fighters.remove(fighter);
    }
  }
}
