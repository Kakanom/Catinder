import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(bool) onThemeChanged;
  final void Function(bool) onSoundChanged;
  final bool isDarkMode;
  final bool soundEnabled;
  final VoidCallback onResetProgress;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.onSoundChanged,
    required this.isDarkMode,
    required this.soundEnabled,
    required this.onResetProgress,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;
  late bool _soundEnabled;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _soundEnabled = widget.soundEnabled;
  }

  void _confirmResetProgress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content:
            const Text('Are you sure you want to reset your likes and streak?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onResetProgress();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
                widget.onThemeChanged(value);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Sound',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
                widget.onSoundChanged(value);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Reset Progress'),
              onTap: _confirmResetProgress,
            ),
          ],
        ),
      ),
    );
  }
}
