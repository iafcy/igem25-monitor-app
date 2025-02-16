import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monitor_mobile_app/utils/models.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsModel>(
        builder: (context, settings, child) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Temperature Unit'),
                  subtitle: Text(
                    settings.useCelsius ? 'Celsius' : 'Fahrenheit',
                  ),
                  trailing: Switch(
                    value: settings.useCelsius,
                    onChanged: (value) {
                      settings.setTemperatureUnit(value);
                    },
                    activeColor: Color(0xff226554),
                    activeTrackColor: Color(0xbf51ad95),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
