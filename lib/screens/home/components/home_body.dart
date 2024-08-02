import 'package:flutter/material.dart';
import 'package:combosender/providers/games_provider.dart';
import 'package:combosender/screens/home/components/home_items_section.dart';
import 'package:combosender/screens/home/components/home_stories_section.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  int _selectedStory = 0;

  @override
  Widget build(BuildContext context) {
    final gamesProvider = Provider.of<GamesProvider>(context);
    final games = gamesProvider.games;

    // Get unique game names for the story section
    final uniqueGameNames = games.map((game) => game.name).toSet().toList();

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Column(
          children: [
            HomeStoriesSection(
              uniqueGameNames: uniqueGameNames,
              games: games,
              selectedStory: _selectedStory,
              onStoryTap: (index) => setState(() {
                _selectedStory = index;
              }),
            ), // Pass games here
            const SizedBox(height: 20),
            HomeItemsSection(
              games: games,
              constraints: constraints,
            )
          ],
        ),
      ),
    );
  }
}
