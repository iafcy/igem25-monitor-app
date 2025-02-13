import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  bool _useCelsius = true;

  bool get useCelsius => _useCelsius;

  SettingsModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _useCelsius = prefs.getBool('useCelsius') ?? true;
    notifyListeners();
  }

  Future<void> setTemperatureUnit(bool useCelsius) async {
    _useCelsius = useCelsius;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useCelsius', useCelsius);
  }
}

class CellData {
  final bool vocDetected;
  final double remainingGM;
  final List<double> humidity;
  final List<double> temperature;

  CellData({
    required this.vocDetected,
    required this.remainingGM,
    required this.humidity,
    required this.temperature,
  });
}