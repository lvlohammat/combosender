import 'package:combosender/constants.dart';
import 'package:combosender/screens/admin/components/admin_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/games_provider.dart';

class ManageGames extends StatelessWidget {
  const ManageGames({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GamesProvider>(
      builder: (context, gamesProvider, child) {
        // Group games by name
        final groupedGames = groupGamesByName(gamesProvider.games);

        return ListView.builder(
          itemCount: groupedGames.keys.length,
          itemBuilder: (context, index) {
            final gameName = groupedGames.keys.elementAt(index);
            final games = groupedGames[gameName]!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ExpansionTile(
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                iconColor: kPrimaryColor,
                collapsedIconColor: kPrimaryColor,
                backgroundColor:
                    const Color.fromARGB(255, 112, 126, 158).withOpacity(.5),
                collapsedBackgroundColor: const Color(0xFF3B4252),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 5),
                tilePadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(
                  gameName,
                  style: const TextStyle(color: kForegroundColor),
                ),
                children: games.map((game) {
                  return Card(
                    margin: const EdgeInsets.all(5),
                    color: const Color(0xFF3B4252),
                    child: ListTile(
                      title: Text(
                        game.title,
                        style: const TextStyle(color: kForegroundColor),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: kSubtitleColor),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminForm(game: game),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: kHeartColor),
                            onPressed: () {
                              gamesProvider.deleteGame(game.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  // Helper function to group games by name
  Map<String, List<Game>> groupGamesByName(List<Game> games) {
    Map<String, List<Game>> groupedGames = {};
    for (final game in games) {
      if (!groupedGames.containsKey(game.name)) {
        groupedGames[game.name] = [];
      }
      groupedGames[game.name]!.add(game);
    }
    return groupedGames;
  }
}
