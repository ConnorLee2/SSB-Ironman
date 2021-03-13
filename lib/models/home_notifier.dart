import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'fighter.dart';
import 'roster_model.dart';

class HomeNotifier extends ChangeNotifier {
  /// Private field backing [roster]
  RosterModel _roster;
  List<Fighter> _searchList;
  int _characterCount;

  /// internal state of player choices
  final List<int> _playerOneIds = [];
  final List<int> _playerTwoIds = [];
  bool _isPlayerOne = true;

  /// The current roster. Used to construct items from numeric ids.
  RosterModel get roster => _roster;
  List<Fighter> get searchList => _searchList;
  int get characterCount => _characterCount;

  set roster(RosterModel newRoster) {
    assert(newRoster != null);
    assert(_playerOneIds.every((id) => newRoster.getById(id) != null),
        'The roster $newRoster does not have one of $_playerOneIds in it.');
    assert(_playerOneIds.every((id) => newRoster.getById(id) != null),
        'The roster $newRoster does not have one of $_playerTwoIds in it.');
    _roster = newRoster;

    notifyListeners();
  }

  set searchList(List<Fighter> fighters) {
    _searchList = fighters;

    notifyListeners();
  }

  /// List of items in player one choices
  List<Fighter> get fighters {
    if (_isPlayerOne) {
      return playerOne;
    } else {
      return playerTwo;
    }
  }

  List<Fighter> get playerOne {
    return _playerOneIds.map((id) => _roster.getById(id)).toList();
  }

  List<Fighter> get playerTwo {
    return _playerTwoIds.map((id) => _roster.getById(id)).toList();
  }

  /// Adds [item] to player roster. This is the only way to modify the player choice
  void add(Fighter item) {
    if (_isPlayerOne) {
      _playerOneIds.add(item.id);
    } else {
      _playerTwoIds.add(item.id);
    }
    notifyListeners();
  }

  bool contains(Fighter item) {
    if (_isPlayerOne) {
      return _playerOneIds.contains(item.id);
    } else {
      return _playerTwoIds.contains(item.id);
    }
  }

  int count() {
    if (_isPlayerOne) {
      return _playerOneIds.length;
    } else {
      return _playerTwoIds.length;
    }
  }

  void remove(Fighter item) {
    if (_isPlayerOne) {
      _playerOneIds.remove(item.id);
    } else {
      _playerTwoIds.remove(item.id);
    }
    notifyListeners();
  }

  void getMaxCharacterCount() {
    var characterCount = Settings.getValue('key-roster-count', 12.0).round();

    // Modify player rosters
    if (characterCount != _characterCount) {
      while (_playerOneIds.length > characterCount) {
        _playerOneIds.removeLast();
      }
      while (_playerTwoIds.length > characterCount) {
        _playerTwoIds.removeLast();
      }
    }

    _characterCount = characterCount;

    notifyListeners();
  }

  void currentSelectedPlayer(bool isPlayerOne) {
    _isPlayerOne = isPlayerOne;
    notifyListeners();
  }

  void clear() {
    if (_isPlayerOne) {
      _playerOneIds.clear();
    } else {
      _playerTwoIds.clear();
    }
    notifyListeners();
  }
}
