import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../providers/games_provider.dart';
import '../../detail/detail_screen.dart';

class HomeStoriesSection extends StatelessWidget {
  final List<String> uniqueGameNames;
  final List<Game> games;
  final int selectedStory;
  final Function(int) onStoryTap;

  const HomeStoriesSection({
    super.key,
    required this.uniqueGameNames,
    required this.games,
    required this.selectedStory,
    required this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: uniqueGameNames.length,
        itemBuilder: (context, index) {
          // Find the first game with the current name
          final game = games.firstWhere(
            (game) => game.name == uniqueGameNames[index],
          );

          return GestureDetector(
            onDoubleTap: () => Navigator.of(context).pushNamed(
              DetailScreen.routeName,
              arguments: game,
            ),
            onTap: () => onStoryTap(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              // Add box shadow only to the selected story
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: selectedStory == index
                    ? Border.all(color: kPrimaryColor, width: 2)
                    : null,
                boxShadow: selectedStory == index
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Adjust offset as needed
                        ),
                      ]
                    : [], // Empty list for no shadow
              ),
              child: CircleAvatar(
                // Use CircleAvatar for rounded image
                radius: 25, // Adjust radius as needed
                backgroundImage: NetworkImage(game.gameIcon),
              ),
            ),
          );
        },
      ),
    );
  }
}
