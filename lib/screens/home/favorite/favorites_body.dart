import 'package:flutter/material.dart';
import 'package:combosender/constants.dart';
import 'package:combosender/providers/games_provider.dart';
import 'package:combosender/screens/detail/detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteBody extends StatefulWidget {
  const FavoriteBody({super.key});

  @override
  State<FavoriteBody> createState() => _FavoriteBodyState();
}

class _FavoriteBodyState extends State<FavoriteBody> {
  @override
  Widget build(BuildContext context) {
    final gamesProvider = Provider.of<GamesProvider>(context);

    // Get unique favorite games by name
    final uniqueFavoriteGames =
        gamesProvider.games.where((game) => game.isFavorite).toList();

    // Group games by name and take the first one from each group
    final uniqueGamesByName = <Game>[];
    final seenNames = <String>{};
    for (final game in uniqueFavoriteGames) {
      if (!seenNames.contains(game.name)) {
        seenNames.add(game.name);
        uniqueGamesByName.add(game);
      }
    }

    return uniqueGamesByName.isEmpty
        ? Center(
            child: Text(
              'No favorite games yet',
              style: _getTextStyle(fontSize: 18, color: kSubtitleColor),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: uniqueGamesByName.length,
            itemBuilder: (context, index) {
              final game = uniqueGamesByName[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(game.gameIcon),
                  ),
                  title: Text(
                    game.name,
                    style: _getTextStyle(
                      color: kTitleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    game.title,
                    style: _getTextStyle(
                      color: kSubtitleColor,
                      fontSize: 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      game.isFavorite
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: game.isFavorite ? kHeartColor : kSubtitleColor,
                    ),
                    onPressed: () {
                      if (game.isFavorite) {
                        _showConfirmationDialog(context, gamesProvider, game);
                      } else {
                        setState(() {
                          gamesProvider.toggleFavoriteByName(game.name);
                          _showSnackBar(context,
                              '${game.name} added to favorites', kHeartColor);
                        });
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(DetailScreen.routeName, arguments: game);
                  },
                ),
              );
            },
          );
  }

  TextStyle _getTextStyle({
    required double fontSize,
    required Color color,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    try {
      return GoogleFonts.nunitoSans(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      );
    } catch (e) {
      return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontFamily: 'Vazirmatn',
      );
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showConfirmationDialog(
      BuildContext context, GamesProvider gamesProvider, Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Favorite'),
          content: Text(
              'Are you sure you want to remove ${game.name} from favorites?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                setState(() {
                  gamesProvider.toggleFavoriteByName(game.name);
                  Navigator.of(context).pop();
                  _showSnackBar(context, '${game.name} removed from favorites',
                      kSubtitleColor);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
