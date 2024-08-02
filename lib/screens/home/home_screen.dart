import 'package:combosender/screens/admin/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:combosender/constants.dart';
import 'package:combosender/screens/home/components/home_body.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:combosender/screens/home/favorite/favorites_body.dart';
import 'package:combosender/screens/home/search/search_body.dart';
import 'package:google_fonts/google_fonts.dart'; // Import FontAwesome
import 'package:combosender/providers/games_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true; // Add loading state

  static const List<Widget> _widgetOptions = <Widget>[
    HomeBody(),
    SearchBody(),
    FavoriteBody(),
    AdminScreen(),
  ];

  static const List<String> _appBarTitles = <String>[
    'Daily Combo',
    'Search',
    'Favorite',
    'admin',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchGames();
  }

  Future<void> _fetchGames() async {
    final gamesProvider = Provider.of<GamesProvider>(context, listen: false);
    await gamesProvider.fetchGames();
    setState(() {
      _isLoading = false; // Set loading to false after fetching
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: kTitleColor.withAlpha(160),
        title: Text(
          _appBarTitles[_selectedIndex],
          style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily ?? 'Vazirmatn'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: kColorScheme.primary),
        backgroundColor: const Color(0xffF5F8FA),
        unselectedIconTheme: const IconThemeData(color: kSubtitleColor),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house), // Use FontAwesome icon
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass), // Use FontAwesome icon
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              _selectedIndex == 2
                  ? FontAwesomeIcons.solidHeart // Solid heart if selected
                  : FontAwesomeIcons.heart, // Regular heart if not selected
            ),
            label: 'Favorite',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.expeditedssl),
            label: 'Admin',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
