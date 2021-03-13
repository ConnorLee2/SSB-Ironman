import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';
import '../models/fighter.dart';
import '../models/home_notifier.dart';

class CharacterPage extends StatefulWidget {
  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var homeNotifer = Provider.of<HomeNotifier>(context, listen: false);
      homeNotifer.searchList = homeNotifer.roster.fighters;
    });
  }

  @override
  Widget build(BuildContext context) {
    var characters = context.watch<HomeNotifier>();
    int characterCount = Settings.getValue('key-roster-count', 12.0).round();
    var charactersListCount = characters.fighters.length;

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: Text(
            'DONE',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.green,
        title: Text(
          'Roster',
          style: Theme.of(context).textTheme.headline1.merge(
                TextStyle(color: Colors.white),
              ),
        ),
        actions: [
          TextButton(
            child: Text(
              'SHUFFLE',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              var characterList = context.read<HomeNotifier>();
              // Clear list
              characterList.clear();

              // Add fighters up to roster count
              do {
                // Random number between 0 - 83
                var random = Random();
                var randomNumber = (random.nextInt(84));
                Fighter fighter = characterList.roster.fighters[randomNumber];

                // Check if the list has the item
                bool doesListHaveItem = characterList.contains(fighter);

                if (!doesListHaveItem) {
                  characterList.add(fighter);
                }
              } while (characterList.count() < characterCount);
            },
          ),
          TextButton(
            child: Text(
              '$charactersListCount / $characterCount',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              print('tapped');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )),
            ),
          ),
          Expanded(
            child: _buildCharacterList(context),
          )
        ],
      ),
    );
  }

  void filterSearchResults(String query) {
    var homeNotifier = Provider.of<HomeNotifier>(context, listen: false);
    List<Fighter> fullList = homeNotifier.roster.fighters;
    List<Fighter> dummySearchList = [];
    if (query.isNotEmpty) {
      // Name
      fullList.forEach((fighter) {
        if (fighter.name.toLowerCase().contains(query.toLowerCase())) {
          dummySearchList.add(fighter);
        }
      });
      // Series
      fullList.forEach((fighter) {
        if (fighter.series.toLowerCase().contains(query.toLowerCase())) {
          if (dummySearchList.contains(fighter)) {
            print('already in searchview');
          } else {
            dummySearchList.add(fighter);
          }
        }
      });
      homeNotifier.searchList = dummySearchList;
    } else {
      homeNotifier.searchList = fullList;
    }
  }

  Widget _buildCharacterList(BuildContext context) {
    var homeNotifier = Provider.of<HomeNotifier>(context, listen: false);

    return ListView.builder(
      itemCount: homeNotifier.searchList.length,
      itemBuilder: (context, index) => _MyListItem(index),
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  _MyListItem(this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var homeNotifier = Provider.of<HomeNotifier>(context, listen: false);
    List<Fighter> fighters = homeNotifier.searchList;
    var fighter = fighters[index];

    var textTheme = Theme.of(context).textTheme.headline6;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                child: Image(
                  image: AssetImage(fighter.getImgName()),
                ),
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: Text(fighter.name, style: textTheme),
            ),
            SizedBox(width: 24),
            _AddButton(item: fighter),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final Fighter item;

  const _AddButton({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isInCharacterList = context.select<HomeNotifier, bool>(
      (characterList) => characterList.fighters.contains(item),
    );

    return TextButton(
      onLongPress: () {
        // reverse
        var characterList = context.read<HomeNotifier>();
        characterList.remove(item);
      },
      onPressed: isInCharacterList
          ? null
          : () {
              var characterList = context.read<HomeNotifier>();
              int characterCount =
                  Settings.getValue('key-roster-count', 12.0).round();
              var characterListCount = characterList.fighters.length;

              if (characterListCount < characterCount) {
                characterList.add(item);
              } else {
                final snackbar = SnackBar(
                    content: Text('Maximum number of characters picked.'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: isInCharacterList
          ? Icon(Icons.check, semanticLabel: 'ADDED')
          : Text('ADD'),
    );
  }
}
