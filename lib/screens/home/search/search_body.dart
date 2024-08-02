import 'package:flutter/material.dart';
import 'package:combosender/constants.dart';
import 'package:combosender/providers/games_provider.dart';
import 'package:combosender/screens/detail/detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({super.key});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gamesProvider = Provider.of<GamesProvider>(context);

    List<Game> getFilteredGames() {
      final uniqueGames = <String, Game>{};
      for (var game in gamesProvider.games) {
        if (game.name.toLowerCase().contains(_searchTerm.toLowerCase())) {
          uniqueGames[game.name] = game;
        }
      }
      return uniqueGames.values.toList();
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Card(
              color: kForegroundColor,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search for games...',
                  prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass,
                      color: kSubtitleColor),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchTerm = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Search Results
            Expanded(
              child: _searchTerm.isEmpty
                  ? const Center(
                      child: Text(
                        'Start typing to search for games...',
                        style: TextStyle(
                          fontSize: 18,
                          color: kSubtitleColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: getFilteredGames().length,
                      itemBuilder: (context, index) {
                        final game = getFilteredGames()[index];

                        return GestureDetector(
                          onTap: () {
                            // Navigate to game detail screen
                            Navigator.pushNamed(context, DetailScreen.routeName,
                                arguments: game);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  game.gameIcon,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                game.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kTitleColor,
                                ),
                              ),
                              subtitle: Text(
                                game.title,
                                style: const TextStyle(
                                  color: kSubtitleColor,
                                ),
                              ),
                              trailing: IconButton.filledTonal(
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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
