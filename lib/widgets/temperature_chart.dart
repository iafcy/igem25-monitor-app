import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:monitor_mobile_app/utils/models.dart';
import 'package:monitor_mobile_app/utils/utils.dart';

class ChartData {
  ChartData(this.time, this.value);
  final int time;
  final double value;
}

class TemperatureChart extends StatelessWidget {
  final List<double>? temperatures;

  const TemperatureChart({super.key, required this.temperatures,});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Current Temperature",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "${(settings.useCelsius ? temperatures!.last : celsiusToFahrenheit(temperatures!.last)).toStringAsFixed(1)}°${settings.useCelsius ? 'C' : 'F'}",
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange[800]
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            height: 175,
            child: SfCartesianChart(
              primaryXAxis: NumericAxis(
                interval: 1,
              ),
              primaryYAxis: NumericAxis(
                minimum: settings.useCelsius ? 10 : 50,
                maximum: settings.useCelsius ? 30 : 90,
                interval: settings.useCelsius ? 5 : 10,
                labelFormat: "{value}°${settings.useCelsius ? 'C' : 'F'}",
              ),
              series: <AreaSeries<ChartData, int>>[
                AreaSeries<ChartData, int>(
                  dataSource: List.generate(temperatures!.length, (index) {
                    return ChartData(index + 1, settings.useCelsius ? temperatures![index] : celsiusToFahrenheit(temperatures![index]));
                  }),
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.value,
                  animationDuration: 750,
                  borderWidth: 2,
                  borderColor: Colors.deepOrange[700]!,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[Colors.orange[50]!, Colors.orange[200]!, Colors.deepOrange[200]!],
                    stops: <double>[0, 0.5, 1.0]
                  ),
                )
              ]
            ),
          ),
        )
      ],
    );
  }
}