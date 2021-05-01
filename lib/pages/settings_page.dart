import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';
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
      body: Column(
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
        ],
      ),
    );
  }
}
