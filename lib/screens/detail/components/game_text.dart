import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants.dart';
import '../../../providers/games_provider.dart';

class GameText extends StatelessWidget {
  const GameText({
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: kPrimaryColor.withOpacity(.1),
        ),
        onPressed: onCopyText,
        icon: Icon(
          copiedIndex == null
              ? FontAwesomeIcons.copy
              : FontAwesomeIcons.solidCopy,
          color: kPrimaryColor,
        ),
        label: Text(
          game.text!,
          style: kMonoTextStyle(
              color: kColorScheme.primary, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
