import 'dart:math';
import 'dart:async';
import 'package:monitor_mobile_app/utils/models.dart';

class GridService {
  final Random _random = Random();

  Future<List<CellData>> fetchGridData() async {
    // placeholder to simulate request
    await Future.delayed(const Duration(seconds: 2));
    
    return List.generate(9, (index) {
      bool vocDetected = _random.nextDouble() > 0.75;
      double remainingGM = _random.nextDouble() * 0.85 + 0.05;
      List<double> humidity = [0.71, 0.6, 0.65, 0.63, 0.61, 0.65, 0.675, 0.6775, 0.68, 0.724];
      List<double> temperature = [16, 17.5, 18.25, 21, 23, 25.5, 22, 21.25, 21, 20.6];
      return CellData(
        vocDetected: vocDetected,
        remainingGM: remainingGM,
        humidity: humidity,
        temperature: temperature
      );
    });
  }
}
