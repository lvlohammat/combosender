import 'package:combosender/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/games_provider.dart';

class AdminForm extends StatefulWidget {
  const AdminForm({super.key, this.game});
  final Game? game;

  @override
  State<AdminForm> createState() => _AdminFormState();
}

class _AdminFormState extends State<AdminForm> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _text;
  String? _videoLink;
  String? _code;
  String? _decodedMorseCode;
  String? _dailyCombo;
  bool _hasExpiryDate = true;

  bool _showTextField = false;
  bool _showVideoField = false;
  bool _showCodeField = false;
  bool _showDecodedMorseField = false;
  bool _showDailyComboField = false;
  bool _isIconFieldEnabled = true;

  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _iconController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _iconController = TextEditingController();

    if (widget.game != null) {
      _nameController.text = widget.game!.name;
      _iconController.text = widget.game!.gameIcon;
      _hasExpiryDate = widget.game!.hasExpiryDate;
      _isIconFieldEnabled = false;
    }

    _nameController.addListener(_updateIconField);
  }

  void _updateIconField() {
    final gamesProvider = Provider.of<GamesProvider>(context, listen: false);
    final matchingGame = gamesProvider.games.firstWhere(
      (game) => game.name.toLowerCase() == _nameController.text.toLowerCase(),
    );

    setState(() {
      if (matchingGame.name.isNotEmpty) {
        _iconController.text = matchingGame.gameIcon;
        _isIconFieldEnabled = false;
      } else {
        _iconController.clear();
        _isIconFieldEnabled = true;
      }
    });
  }

  Widget _buildTextFormField(String labelText, TextEditingController controller,
      {bool enabled = true, Function(String?)? onSaved, String? hintText}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: kFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: kTextStyle(color: kFormForegroundColor),
        hintStyle: kTextStyle(color: kSubtitleColor),
      ),
      style: kTextStyle(color: kFormForegroundColor),
      enabled: enabled,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText cannot be empty';
        }
        if (labelText == 'Game Icon URL' || labelText == 'Daily Combo') {
          if (!value.startsWith('http')) {
            return '$labelText must be a valid URL';
          }
        }
        return null;
      },
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?)? onChanged) {
    return GestureDetector(
      onTap: () {
        onChanged!(!value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
          ),
          Text(
            label,
            style: kTextStyle(color: kFormForegroundColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gamesProvider = Provider.of<GamesProvider>(context);
    final allGameNames =
        gamesProvider.games.map((game) => game.name).toSet().toList();

    return Scaffold(
      backgroundColor: kFormBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildCheckbox('Text', _showTextField, (value) {
                      setState(() {
                        _showTextField = value!;
                      });
                    }),
                    _buildCheckbox('Video', _showVideoField, (value) {
                      setState(() {
                        _showVideoField = value!;
                      });
                    }),
                    _buildCheckbox('Code', _showCodeField, (value) {
                      setState(() {
                        _showCodeField = value!;
                      });
                    }),
                    _buildCheckbox('Decoded Morse', _showDecodedMorseField,
                        (value) {
                      setState(() {
                        _showDecodedMorseField = value!;
                      });
                    }),
                    _buildCheckbox('Daily Combo', _showDailyComboField,
                        (value) {
                      setState(() {
                        _showDailyComboField = value!;
                      });
                    }),
                  ],
                ),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return allGameNames.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (String option) => option,
                  onSelected: (String selection) {
                    final gamesProvider =
                        Provider.of<GamesProvider>(context, listen: false);
                    final matchingGame = gamesProvider.games.firstWhere(
                      (game) =>
                          game.name.toLowerCase() == selection.toLowerCase(),
                    );
                    setState(() {
                      _nameController.text = matchingGame.name;
                      _iconController.text = matchingGame.gameIcon;
                      _hasExpiryDate = matchingGame.hasExpiryDate;
                      _isIconFieldEnabled = false;
                    });
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted) {
                    _nameController = fieldTextEditingController;
                    return TextFormField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor: kFillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelStyle: kTextStyle(color: kFormForegroundColor),
                      ),
                      style: kTextStyle(color: kFormForegroundColor),
                    );
                  },
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<String> onSelected,
                      Iterable<String> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: kFillColor,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return GestureDetector(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      text: option.substring(
                                          0, _nameController.text.length),
                                      style: kTextStyle(color: Colors.white),
                                      children: [
                                        TextSpan(
                                          text: option.substring(
                                              _nameController.text.length),
                                          style:
                                              kTextStyle(color: Colors.white38),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildTextFormField('Title', _titleController,
                    onSaved: (value) {
                  _title = _convertToCamelCase(value!);
                }),
                const SizedBox(height: 10),
                _buildTextFormField('Game Icon URL', _iconController,
                    enabled: _isIconFieldEnabled, onSaved: (value) {
                  _iconController.text = value!;
                }, hintText: 'https://example.com/image.jpg'),
                const SizedBox(height: 10),
                if (_showTextField)
                  _buildTextFormField('Text', TextEditingController(),
                      onSaved: (value) {
                    _text = value;
                  }),
                const SizedBox(height: 10),
                if (_showVideoField)
                  _buildTextFormField('Video Link', TextEditingController(),
                      onSaved: (value) {
                    _videoLink = value;
                  }),
                const SizedBox(height: 10),
                if (_showCodeField)
                  _buildTextFormField('Code', TextEditingController(),
                      onSaved: (value) {
                    _code = value;
                  }),
                const SizedBox(height: 10),
                if (_showDecodedMorseField)
                  _buildTextFormField(
                      'Decoded Morse Code', TextEditingController(),
                      onSaved: (value) {
                    _decodedMorseCode = value;
                  }),
                const SizedBox(height: 10),
                if (_showDailyComboField)
                  _buildTextFormField('Daily Combo', TextEditingController(),
                      onSaved: (value) {
                    _dailyCombo = value;
                  }, hintText: 'https://example.com/dailycombo.jpg'),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Has Expiry Date',
                      style: TextStyle(color: kFormForegroundColor)),
                  value: _hasExpiryDate,
                  onChanged: (value) {
                    setState(() {
                      _hasExpiryDate = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final game = Game(
                            id: widget.game?.id ?? '',
                            name: _nameController.text,
                            title: _title!,
                            date: DateTime.now().toIso8601String(),
                            gameIcon: _iconController.text,
                            text: _text,
                            videoLink: _videoLink,
                            code: _code,
                            decodedMorseCode: _decodedMorseCode,
                            dailyComboImage: _dailyCombo,
                            hasExpiryDate: _hasExpiryDate,
                          );
                          if (widget.game == null) {
                            Provider.of<GamesProvider>(context, listen: false)
                                .addGame(game);
                          } else {
                            Provider.of<GamesProvider>(context, listen: false)
                                .updateGame(game);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Game Saved!')),
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                        setState(() {
                          _nameController.clear();
                          _titleController.clear();
                          _iconController.clear();
                          _hasExpiryDate = true;
                          _showTextField = false;
                          _showVideoField = false;
                          _showCodeField = false;
                          _showDecodedMorseField = false;
                          _showDailyComboField = false;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _convertToCamelCase(String value) {
    return value
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
