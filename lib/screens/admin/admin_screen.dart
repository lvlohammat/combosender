import 'package:combosender/constants.dart';
import 'package:combosender/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'components/admin_form.dart';
import 'components/manage_games.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedSegment = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF2E3440), // Background color from admin_form.dart
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF3B4252), // AppBar color from admin_form.dart
        title: const Text(
          'Admin Panel',
          style: TextStyle(color: kForegroundColor),
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen())),
            icon: const Icon(
                FontAwesomeIcons.house)), // Text color from admin_form.dart
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                  const TextStyle(color: kForegroundColor),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(
                          0xFF5e81ac); // Color for selected segment
                    }
                    return const Color(
                        0xFF3B4252); // Color for unselected segments
                  },
                ),
                foregroundColor: const WidgetStatePropertyAll(kForegroundColor),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                ),
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              segments: const <ButtonSegment<int>>[
                ButtonSegment<int>(
                  value: 0,
                  label: Text('Add Game',
                      style: TextStyle(
                          color:
                              kForegroundColor)), // Text color from admin_form.dart
                  icon: Icon(Icons.add,
                      color:
                          kForegroundColor), // Icon color from admin_form.dart
                ),
                ButtonSegment<int>(
                  value: 1,
                  label: Text('Manage Games',
                      style: TextStyle(
                          color:
                              kForegroundColor)), // Text color from admin_form.dart
                  icon: Icon(Icons.edit,
                      color:
                          kForegroundColor), // Icon color from admin_form.dart
                ),
              ],
              selected: <int>{_selectedSegment},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _selectedSegment = newSelection.first;
                });
              },
            ),
          ),
          Expanded(
            child:
                _selectedSegment == 0 ? const AdminForm() : const ManageGames(),
          ),
        ],
      ),
    );
  }
}
