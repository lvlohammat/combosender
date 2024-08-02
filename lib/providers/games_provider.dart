import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamesProvider with ChangeNotifier {
  List<Game> _games = [];
  List<Guide> _guides = [];

  List<Game> get games => _games;
  List<Guide> get guides => _guides;

  // Shared preferences instance
  late SharedPreferences _prefs;

  // Initialize shared preferences in the constructor
  GamesProvider() {
    _initSharedPreferences();
  }

  // Initialize shared preferences
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> fetchGames() async {
    final response = await ParseObject('Game').getAll();
    if (response.success && response.results != null) {
      _games = response.results!.map((e) => Game.fromParse(e)).toList();
      // Load favorite status from shared preferences
      _loadFavoriteStatus();
      notifyListeners();
    }
  }

  // Load favorite status from shared preferences
  void _loadFavoriteStatus() {
    for (final game in _games) {
      game.isFavorite = _prefs.getBool(game.name) ?? false;
    }
  }

  // Save favorite status to shared preferences
  void _saveFavoriteStatus(String gameName, bool isFavorite) {
    _prefs.setBool(gameName, isFavorite);
  }

  Future<void> fetchGuides() async {
    final response = await ParseObject('Guide').getAll();
    if (response.success && response.results != null) {
      _guides = response.results!.map((e) => Guide.fromParse(e)).toList();
      notifyListeners();
    }
  }

  Future<void> addGame(Game game) async {
    final parseObject = ParseObject('Game')
      ..set('name', game.name)
      ..set('title', game.title)
      ..set('gameIcon', game.gameIcon)
      ..set('text', game.text)
      ..set('videoLink', game.videoLink)
      ..set('dailyComboImage', game.dailyComboImage)
      ..set('decodedMorseCode', game.decodedMorseCode)
      ..set('code', game.code)
      ..set('hasExpiryDate', game.hasExpiryDate);

    final response = await parseObject.save();
    if (response.success) {
      final newGame = Game.fromParse(response.result);
      _games.add(newGame);
      notifyListeners();
    }
  }

  Future<void> updateGame(Game game) async {
    final parseObject = ParseObject('Game')
      ..objectId = game.id
      ..set('name', game.name)
      ..set('title', game.title)
      ..set('gameIcon', game.gameIcon)
      ..set('dailyComboImage', game.dailyComboImage)
      ..set('text', game.text)
      ..set('code', game.code)
      ..set('decodedMorseCode', game.decodedMorseCode)
      ..set('videoLink', game.videoLink)
      ..set('hasExpiryDate', game.hasExpiryDate);

    final response = await parseObject.save();
    if (response.success) {
      final index = _games.indexWhere((element) => element.id == game.id);
      if (index != -1) {
        _games[index] = game;
        notifyListeners();
      }
    }
  }

  Future<void> deleteGame(String id) async {
    final parseObject = ParseObject('Game')..objectId = id;

    final response = await parseObject.delete();
    if (response.success) {
      _games.removeWhere((element) => element.id == id);
      notifyListeners();
    }
  }

  void toggleFavoriteByName(String gameName) {
    final matchingGames =
        _games.where((game) => game.name == gameName).toList();

    for (final game in matchingGames) {
      game.isFavorite = !game.isFavorite;
      // Update shared preferences
      _saveFavoriteStatus(gameName, game.isFavorite);
    }

    notifyListeners();
  }

  Future<void> addGuide(Guide guide) async {
    final parseObject = ParseObject('Guide')
      ..set('gameName', guide.gameName)
      ..set('hints', guide.hints)
      ..set('images', guide.images)
      ..set('displayOrder', guide.displayOrder);

    final response = await parseObject.save();
    if (response.success) {
      final newGuide = Guide.fromParse(response.result);
      _guides.add(newGuide);
      notifyListeners();
    }
  }

  Future<void> updateGuide(Guide guide) async {
    final parseObject = ParseObject('Guide')
      ..set('gameName', guide.gameName)
      ..set('hints', guide.hints)
      ..set('images', guide.images)
      ..set('displayOrder', guide.displayOrder);

    final response = await parseObject.save();
    if (response.success) {
      final index =
          _guides.indexWhere((element) => element.gameName == guide.gameName);
      if (index != -1) {
        _guides[index] = guide;
        notifyListeners();
      }
    }
  }

  Future<void> deleteGuide(String gameName) async {
    final parseObject = ParseObject('Guide')..set('gameName', gameName);

    final response = await parseObject.delete();
    if (response.success) {
      _guides.removeWhere((element) => element.gameName == gameName);
      notifyListeners();
    }
  }

  Guide? getGuideByGameName(String gameName) {
    try {
      return _guides.firstWhere((guide) => guide.gameName == gameName);
    } catch (e) {
      return null;
    }
  }
}

class Game {
  final String name;
  final String title;
  final String id;
  final String date;
  final String gameIcon;
  final String? text;
  final String? decodedMorseCode;
  final String? dailyComboImage;
  final String? videoLink;
  final String? code;
  bool isFavorite;
  final bool hasExpiryDate;

  Game({
    required this.name,
    required this.id,
    required this.title,
    required this.date,
    required this.gameIcon,
    this.text,
    this.decodedMorseCode,
    this.dailyComboImage,
    this.videoLink,
    this.code,
    this.hasExpiryDate = true,
    this.isFavorite = false,
  });

  // Factory constructor to parse ParseObject
  factory Game.fromParse(ParseObject parseObject) {
    return Game(
      id: parseObject.objectId!,
      name: parseObject.get<String>('name')!,
      title: parseObject.get<String>('title')!,
      date: parseObject.get<DateTime>('createdAt')!.toIso8601String(),
      gameIcon: parseObject.get<String>('gameIcon')!,
      text: parseObject.get<String?>('text'),
      decodedMorseCode: parseObject.get<String?>('decodedMorseCode'),
      dailyComboImage: parseObject.get<String?>('dailyComboImage'),
      videoLink: parseObject.get<String?>('videoLink'),
      code: parseObject.get<String?>('code'),
      hasExpiryDate: parseObject.get<bool>('hasExpiryDate') ?? true,
    );
  }
}

class Guide {
  final String gameName;
  final List<String>? hints; // Optional list of hints
  final List<String>? images; // Optional list of images
  final List<int>?
      displayOrder; // Optional list of display order (1 for hint, 2 for image)

  Guide({
    required this.gameName,
    this.hints,
    this.images,
    this.displayOrder,
  });

  // Factory constructor to parse ParseObject
  factory Guide.fromParse(ParseObject parseObject) {
    return Guide(
      gameName: parseObject.get<String>('gameName')!,
      hints: parseObject.get<List<String>?>('hints'),
      images: parseObject.get<List<String>?>('images'),
      displayOrder: parseObject.get<List<int>?>('displayOrder'),
    );
  }
}
