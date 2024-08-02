import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants.dart';
import '../../../providers/games_provider.dart';

class GameVideoLink extends StatelessWidget {
  const GameVideoLink({
    super.key,
    required this.game,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        // Open the video link in a new browser tab or app
        // You can use the `launch` package for this
        // launch(game.videoLink!);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: kPrimaryColor.withOpacity(0.1),
        // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: const Icon(
        FontAwesomeIcons.youtube,
        color: kPrimaryColor,
        size: 20,
      ),
      label: Text(
        'Watch Video',
        style: kTextStyle(
          color: kPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
