import 'package:flutter/material.dart';
import 'package:combosender/screens/detail/components/game_codes.dart';
import 'package:combosender/screens/detail/components/game_morse_code.dart';
import 'package:combosender/screens/detail/components/game_text.dart';
import 'package:combosender/screens/detail/components/game_title_and_date.dart';
import 'package:combosender/screens/detail/components/game_video_button.dart';

import '../../../providers/games_provider.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.game,
    required this.copiedIndex,
    required this.onCopyText,
  });

  final Game game;
  final int? copiedIndex;
  final VoidCallback onCopyText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GameTitleAndDate(game: game),
            if (game.dailyComboImage == null)
              const SizedBox(
                height: 24,
              ),
            if (game.text != null)
              GameText(
                game: game,
                copiedIndex: copiedIndex,
                onCopyText: onCopyText,
              ),
            if (game.decodedMorseCode != null) GameMorseCode(game: game),
            const SizedBox(height: 8),
            if (game.code != null) GameCode(game: game),
            const SizedBox(height: 8),
            if (game.videoLink != null) GameVideoLink(game: game),
          ],
        ),
      ),
    );
  }
}
