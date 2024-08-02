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

  @override
  Widget build(BuildContext context) {
    final Game initialGame = ModalRoute.of(context)!.settings.arguments as Game;

    // Get all games with the same name from the provider
    final gamesProvider = Provider.of<GamesProvider>(context);
    final gamesWithSameName = gamesProvider.games
        .where((game) => game.name == initialGame.name)
        .toList();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        foregroundColor: kTitleColor.withAlpha(160),
        title: Text(initialGame.name,
            style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily ?? 'Vazirmatn')),
        actions: [
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
            for (int i = 0; i < gamesWithSameName.length; i++)
              GameTimelineTile(
                game: gamesWithSameName[i],
                isFirst: i == 0,
                isLast: i == gamesWithSameName.length - 1,
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
