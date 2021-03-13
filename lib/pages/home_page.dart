import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:provider/provider.dart';
import 'package:ssbu_ironman/models/home_notifier.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var homeNotifier = Provider.of<HomeNotifier>(context, listen: false);
      homeNotifier.getMaxCharacterCount();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.index == 0) {
      var gameModel = context.read<HomeNotifier>();
      gameModel.currentSelectedPlayer(true);
    } else {
      var gameModel = context.read<HomeNotifier>();
      gameModel.currentSelectedPlayer(false);
    }
  }

  Column _buildPlayerCharacterChoicesScreen(bool isPlayerOne) {
    var homeNotifier = context.watch<HomeNotifier>();
    int characterCount = homeNotifier.characterCount;
    var charactersListCount = homeNotifier.fighters.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Text(
            'Character count: $charactersListCount / $characterCount',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: _CharacterList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Ironman'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings_sharp),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
            TextButton(
              child: Text(
                'START',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                var characters =
                    Provider.of<HomeNotifier>(context, listen: false);
                var playerOneList = characters.playerOne;
                var playerTwoList = characters.playerTwo;
                int characterCount =
                    Settings.getValue('key-roster-count', 12.0).round();

                if (playerOneList.length == characterCount &&
                    playerTwoList.length == characterCount) {
                  Navigator.pushNamed(context, '/game');
                } else if (playerOneList.length != characterCount) {
                  final snackbar = SnackBar(
                      content:
                          Text('Not enough characters picked in P1\'s roster'));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                } else if (playerTwoList.length != characterCount) {
                  final snackbar = SnackBar(
                      content:
                          Text('Not enough characters picked in P2\'s roster'));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                } else {
                  final snackbar =
                      SnackBar(content: Text('Not enough characters picked.'));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              },
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Player 1', icon: Icon(Icons.pan_tool_sharp)),
              Tab(text: 'Player 2', icon: Icon(Icons.pan_tool_sharp)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPlayerCharacterChoicesScreen(true),
            _buildPlayerCharacterChoicesScreen(false),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/characters'),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class _CharacterList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.headline6;
    var characters = context.watch<HomeNotifier>();

    return ListView.builder(
      itemCount: characters.fighters.length,
      itemBuilder: (context, index) => ListTile(
        leading: Image(
          image: AssetImage(characters.fighters[index].getImgName()),
        ),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {
            characters.remove(characters.fighters[index]);
          },
        ),
        title: Text(
          characters.fighters[index].name,
          style: itemNameStyle,
        ),
      ),
    );
  }
}
