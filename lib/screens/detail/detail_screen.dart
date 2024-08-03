import 'package:flutter/material.dart';
import 'package:combosender/constants.dart';
import 'package:combosender/providers/games_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'components/game_timeline_tile.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});
  static const String routeName = '/detail';

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? copiedIndex;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final Game initialGame = ModalRoute.of(context)!.settings.arguments as Game;

    // Get all games with the same name from the provider
    final gamesProvider = Provider.of<GamesProvider>(context);
    final gamesWithSameName = gamesProvider.games
        .where((game) => game.name == initialGame.name)
        .toList();

    // Filter games based on search query
    final filteredGames = _isSearching
        ? gamesWithSameName
            .where((game) =>
                game.title.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList()
        : gamesWithSameName;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        foregroundColor: kTitleColor.withAlpha(160),
        title: _isSearching
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by title',
                    hintStyle: kTextStyle(color: kSubtitleColor, fontSize: 16),
                    prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass,
                        color: kSubtitleColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  style: kTextStyle(
                      color: kPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )
            : Text(initialGame.name,
                style: TextStyle(
                    fontFamily:
                        GoogleFonts.poppins().fontFamily ?? 'Vazirmatn')),
        actions: [
          if (!_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              icon: const Icon(FontAwesomeIcons.magnifyingGlass),
            ),
          if (_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchQuery = '';
                });
              },
              icon: const Icon(FontAwesomeIcons.xmark),
            ),
          IconButton(
            onPressed: () {
              gamesProvider.toggleFavoriteByName(initialGame.name);
            },
            icon: Icon(
              initialGame.isFavorite
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              color: initialGame.isFavorite ? kHeartColor : kSubtitleColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.question),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < filteredGames.length; i++)
              GameTimelineTile(
                game: filteredGames[i],
                isFirst: i == 0,
                isLast: i == filteredGames.length - 1,
                copiedIndex: copiedIndex,
                onCopyText: () {
                  setState(() {
                    copiedIndex = i;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: kPrimaryColor,
                      content: Text('Copy'),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
