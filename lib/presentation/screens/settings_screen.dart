import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cat_bloc.dart';
import '../blocs/cat_event.dart';
import '../blocs/cat_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _confirmResetProgress(BuildContext context) {
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
              context.read<CatBloc>().add(ResetProgressEvent());
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
    return BlocBuilder<CatBloc, CatState>(
      builder: (context, state) {
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
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (value) =>
                      context.read<CatBloc>().add(ToggleThemeEvent(value)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: const Text('Reset Progress'),
                  onTap: () => _confirmResetProgress(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
