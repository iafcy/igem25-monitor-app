import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HistoryTimeOption {
  hour('Past hour'),
  day('Past day'),
  week('Past week'),
  month('Past month');

  final String value;
  const HistoryTimeOption(this.value);
}

class SettingsModel extends ChangeNotifier {
  bool _useCelsius = true;
  String _historyTimeOption = HistoryTimeOption.hour.value;

  bool get useCelsius => _useCelsius;
  String get historyTimeOption => _historyTimeOption;

  SettingsModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _useCelsius = prefs.getBool('useCelsius') ?? true;
    _historyTimeOption = prefs.getString('historyTimeOption') ?? HistoryTimeOption.hour.value;
    notifyListeners();
  }

  Future<void> setTemperatureUnit(bool useCelsius) async {
    _useCelsius = useCelsius;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useCelsius', useCelsius);
  }

  Future<void> setHistoryTimeOption(String historyTimeOption) async {
    _historyTimeOption = historyTimeOption;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('historyTimeOption', historyTimeOption);
  }
}

class CellData {
  final bool vocDetected;
  final List<double> humidity;
  final List<double> temperature;

  CellData({
    required this.vocDetected,
    required this.humidity,
    required this.temperature,
  });
}

class SensorData {
  final double remainingGM;
  final List<CellData> grid;

  SensorData({
    required this.remainingGM,
    required this.grid,
  });
}