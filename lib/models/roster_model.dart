import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'dart:convert';

import 'fighter.dart';

/// Super Smash Bros. Ulimate Roster
class RosterModel {
  List<Fighter> fighters = [];

  RosterModel() {
    initFightersList();
  }

  Future<String> getJson() {
    return rootBundle.loadString('assets/rosters/roster_ssbu.json');
  }

  Future<void> initFightersList() async {
    var parsed = json.decode(await getJson());
    List<Fighter> list =
        List<Fighter>.from(parsed.map((i) => Fighter.fromJson(i)));

    fighters = list;

    _removeDLC();
  }

  void _removeDLC() {
    var dlcPlant = Settings.getValue('key-roster-sf-plant', true);
    if (!dlcPlant) {
      fighters.removeWhere((element) => element.id == 74);
    }

    var dlcJoker = Settings.getValue('key-roster-fp1-joker', true);
    if (!dlcJoker) {
      fighters.removeWhere((element) => element.id == 75);
    }

    var dlcHero = Settings.getValue('key-roster-fp1-hero', true);
    if (!dlcHero) {
      fighters.removeWhere((element) => element.id == 76);
    }

    var dlcBk = Settings.getValue('key-roster-fp1-bk', true);
    if (!dlcBk) {
      fighters.removeWhere((element) => element.id == 77);
    }

    var dlcTerry = Settings.getValue('key-roster-fp1-terry', true);
    if (!dlcTerry) {
      fighters.removeWhere((element) => element.id == 78);
    }

    var dlcByleth = Settings.getValue('key-roster-fp1-byleth', true);
    if (!dlcByleth) {
      fighters.removeWhere((element) => element.id == 79);
    }

    var dlcMinmin = Settings.getValue('key-roster-fp2-minmin', true);
    if (!dlcMinmin) {
      fighters.removeWhere((element) => element.id == 80);
    }

    var dlcSteve = Settings.getValue('key-roster-fp2-steve', true);
    if (!dlcSteve) {
      fighters.removeWhere((element) => element.id == 81);
    }

    var dlcSephi = Settings.getValue('key-roster-fp2-sephiroth', true);
    if (!dlcSephi) {
      fighters.removeWhere((element) => element.id == 82);
    }

    var dlcPyra = Settings.getValue('key-roster-fp2-pyra', true);
    if (!dlcPyra) {
      fighters.removeWhere((element) => element.id == 83);
    }
  }

  Fighter getById(int id) => fighters[id];
}
