import 'package:flutter/cupertino.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'battle_character.dart';

class GameNotifier extends ChangeNotifier {
  // Fields
  List<BattleCharacter> _playerOneCharacters;
  List<BattleCharacter> _playerTwoCharacters;
  BattleCharacter _currentPlayerOneFighter;
  BattleCharacter _currentPlayerTwoFighter;

  // Getters
  List<BattleCharacter> get playerOneList {
    return _playerOneCharacters;
  }

  List<BattleCharacter> get playerTwoList {
    return _playerTwoCharacters;
  }

  BattleCharacter get currentPlayerOne => _currentPlayerOneFighter;
  BattleCharacter get currentPlayerTwo => _currentPlayerTwoFighter;

  set playerOneList(List<BattleCharacter> newList) {
    assert(newList != null);
    _playerOneCharacters = newList;

    notifyListeners();
  }

  set playerTwoList(List<BattleCharacter> newList) {
    assert(newList != null);
    _playerTwoCharacters = newList;

    notifyListeners();
  }

  set currentPlayerOne(BattleCharacter newFighter) {
    assert(newFighter != null);
    _currentPlayerOneFighter = newFighter;

    notifyListeners();
  }

  set currentPlayerTwo(BattleCharacter newFighter) {
    assert(newFighter != null);
    _currentPlayerTwoFighter = newFighter;

    notifyListeners();
  }

  void updateStockCount(
      bool isPlayerOne, BattleCharacter character, int stockCount) {
    character.stockCount = character.stockCount + stockCount;
    int settingsStockCount = Settings.getValue('key-stock-count', 4.0).round();

    if (character.stockCount > settingsStockCount) {
      character.stockCount = 4;
    } else if (character.stockCount <= 0) {
      character.stockCount = 0;

      if (isPlayerOne) {
        // Get index of current selected character
        var index = playerOneList.indexOf(character);

        // selected next character
        if ((index + 1) < playerOneList.length) {
          currentPlayerOne = playerOneList[index + 1];
        }
      } else {
        var index = playerTwoList.indexOf(character);
        if ((index + 1) < playerTwoList.length) {
          currentPlayerTwo = playerTwoList[index + 1];
        }
      }
    }

    notifyListeners();
  }
}
