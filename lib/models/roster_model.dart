import 'package:flutter/services.dart' show rootBundle;
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
  }

  Fighter getById(int id) => fighters[id];
}
