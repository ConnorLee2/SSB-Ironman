import 'package:auto_size_text/auto_size_text.dart';

/// Pick opening character for both sides
/// Coin flip for first pick?
///  Play out game. When a player loses all of their characters stocks,
/// they pick another character and the stage.
/// 5.a write out remaining stocks for winner.
/// 6. Winner of prior game starts the new battle with their characters
/// remaining stocks (SD until it matches prior stock count)

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';

import '../models/game_notifier.dart';
import '../models/fighter.dart';
import '../models/battle_character.dart';
import '../models/home_notifier.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add player one and player two rosters to battle model
      var homeNotifier = Provider.of<HomeNotifier>(context, listen: false);
      var playerOneItemList = homeNotifier.playerOne;
      var playerTwoItemList = homeNotifier.playerTwo;

      var playerOneCharacters = <BattleCharacter>[];
      var playerTwoCharacters = <BattleCharacter>[];

      // Get stock count
      int stockCount = Settings.getValue('key-stock-count', 4.0).round();

      // Convert item list into characters list
      for (Fighter item in playerOneItemList) {
        var char = BattleCharacter(item, stockCount);
        playerOneCharacters.add(char);
      }

      for (Fighter item in playerTwoItemList) {
        var char = BattleCharacter(item, stockCount);
        playerTwoCharacters.add(char);
      }

      // Update player lists in battle model
      var battle = Provider.of<GameNotifier>(context, listen: false);
      battle.playerOneList = playerOneCharacters;
      battle.playerTwoList = playerTwoCharacters;

      // Set first character
      battle.currentPlayerOne = battle.playerOneList.first;
      battle.currentPlayerTwo = battle.playerTwoList.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Game',
          style: Theme.of(context).textTheme.headline1.merge(
                TextStyle(color: Colors.white),
              ),
        ),
        actions: [
          TextButton(
              child: Text(
                'RESET',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // clear rosters
                var characters =
                    Provider.of<HomeNotifier>(context, listen: false);
                characters.currentSelectedPlayer(true);
                characters.clear();
                characters.currentSelectedPlayer(false);
                characters.clear();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (Route<dynamic> route) => false,
                );
              }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: _buildRosterLists(context),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 2,
            child: Card(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        child: _buildBattleCharacter(context, true),
                        color: Colors.blue.withOpacity(0.8),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        child: _buildBattleCharacter(context, false),
                        color: Colors.red.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleCharacter(BuildContext context, bool isPlayerOne) {
    var battle = Provider.of<GameNotifier>(context);
    var battleCharacter = BattleCharacter(null, null);

    if (isPlayerOne) {
      battleCharacter = battle.currentPlayerOne;
    } else {
      battleCharacter = battle.currentPlayerTwo;
    }

    var image;

    String backgroundString = battleCharacter.fighter.getBackgroundString();
    if (backgroundString.contains('png')) {
      image = AssetImage(backgroundString);
    } else {
      image = Svg(backgroundString);
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: image, fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: _buildStockCountList(context, battleCharacter),
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.fill,
              child: IconButton(
                icon: Icon(
                  Icons.add_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  battle.updateStockCount(isPlayerOne, battleCharacter, 1);
                },
              ),
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.fill,
              child: IconButton(
                icon: Icon(
                  Icons.remove_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  battle.updateStockCount(isPlayerOne, battleCharacter, -1);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Flexible> _buildStockCountList(
      BuildContext context, BattleCharacter battleCharacter) {
    List<Flexible> images = [];

    for (int i = 0; i < battleCharacter.stockCount; i++) {
      Image image =
          Image(image: AssetImage(battleCharacter.fighter.getImgName()));

      Flexible flex = Flexible(child: image);
      images.add(flex);
    }

    return images;
  }

  Widget _buildRosterLists(BuildContext context) {
    // TODO: character count x characters alive / number characters
    var battle = Provider.of<GameNotifier>(context);
    var playerOneListLength = battle.playerOneList.length;
    var playerTwoListLength = battle.playerTwoList.length;

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.blue.withOpacity(0.8),
                      child: Center(
                          child: Text('Player One',
                              style: Theme.of(context).textTheme.headline5)),
                    ),
                  )
                ],
              ),
              Expanded(
                child: _buildPlayerList(context, true),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.red.withOpacity(0.8),
                      child: Center(
                          child: Text('Player Two',
                              style: Theme.of(context).textTheme.headline5)),
                    ),
                  )
                ],
              ),
              Expanded(
                child: _buildPlayerList(context, false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerList(BuildContext context, bool isPlayerOne) {
    var battle = Provider.of<GameNotifier>(context);
    List<BattleCharacter> playerRosterList = [];

    if (isPlayerOne) {
      playerRosterList = battle.playerOneList;
    } else {
      playerRosterList = battle.playerTwoList;
    }

    return ListView.builder(
      itemCount: battle.playerOneList.length,
      itemBuilder: (context, index) => ListTile(
        leading: Image(
          image: AssetImage(
            playerRosterList[index].fighter.getImgName(),
          ),
          width: (MediaQuery.of(context).size.width * 0.1),
        ),
        trailing: Text('${playerRosterList[index].stockCount}'),
        title: AutoSizeText(
          playerRosterList[index].fighter.name,
          style: TextStyle(color: Colors.white),
          wrapWords: false,
          minFontSize: 8,
          maxLines: 2,
        ),
        onTap: () {
          var character = playerRosterList[index];
          if (isPlayerOne) {
            battle.currentPlayerOne = character;
          } else {
            battle.currentPlayerTwo = character;
          }
        },
      ),
    );
  }
}
