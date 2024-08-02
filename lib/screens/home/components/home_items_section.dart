import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../providers/games_provider.dart';

class HomeItemsSection extends StatelessWidget {
  const HomeItemsSection({
    super.key,
    required this.games,
    required this.constraints,
  });

  final List<Game> games;
  final BoxConstraints constraints;

  String _convertToPersianDate(String date) {
    final dateTime = DateTime.parse(date);
    return dateTime.toPersianDateStr(showDayStr: true);
  }

  @override
  Widget build(BuildContext context) {
    final gamesProvider = Provider.of<GamesProvider>(context);

    // Get unique game names
    final uniqueGameNames = games.map((game) => game.name).toSet();

    return Container(
      margin: const EdgeInsets.all(10),
      height: constraints.maxHeight - 70,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust grid columns based on screen width
          int crossAxisCount = constraints.maxWidth > 800
              ? 4
              : constraints.maxWidth > 600
                  ? 3
                  : 2;
          double childAspectRatio = constraints.maxWidth > 600 ? 1 : 0.75;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: uniqueGameNames.length, // Use the set's length
            itemBuilder: (context, index) {
              // Find the first game with the corresponding name
              final game = games.firstWhere(
                  (game) => game.name == uniqueGameNames.elementAt(index));

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate button height as a fraction of screen height
                      double buttonHeight = constraints.maxHeight * 0.15;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton.filledTonal(
                                style: IconButton.styleFrom(
                                  backgroundColor: game.isFavorite
                                      ? kHeartColor.withOpacity(.1)
                                      : kForegroundColor.withOpacity(.8),
                                ),
                                onPressed: () {
                                  gamesProvider.toggleFavoriteByName(game.name);
                                },
                                icon: Icon(
                                  game.isFavorite
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart,
                                  color: game.isFavorite
                                      ? kHeartColor
                                      : kSubtitleColor,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryColor,
                            ),
                            width: constraints.maxWidth / 1.5,
                            height: constraints.maxHeight / 3,
                            margin: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(game.gameIcon),
                            ),
                          ),
                          Text(
                            game.name,
                            style: kTextStyle(
                                fontSize: 20,
                                color: kTitleColor,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            _convertToPersianDate(game.date),
                            style: const TextStyle(
                              color: kSubtitleColor,
                              fontWeight: FontWeight.w200,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/detail',
                                    arguments: game);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    Size(double.infinity, buttonHeight),
                                backgroundColor: kSubtitleColor.withOpacity(.2),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text('Click For More'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
