import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.time, this.value);
  final int time;
  final double value;
}

class HumidityChart extends StatelessWidget {
  final List<double>? humiditys;

  const HumidityChart({super.key, required this.humiditys,});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Current Humidity",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "${(humiditys!.last * 100).toStringAsFixed(1)}%",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue[800],
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
                minimum: 0,
                maximum: 1,
                interval: 0.2,
                numberFormat: NumberFormat.percentPattern(),
              ),
              series: < AreaSeries<ChartData, int>>[
                 AreaSeries<ChartData, int>(
                  dataSource: List.generate(humiditys!.length, (index) {
                    return ChartData(index + 1, humiditys![index]);
                  }),
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.value,
                  animationDuration: 750,
                  borderWidth: 2,
                  borderColor: Colors.blue[700]!,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[Colors.blue[50]!, Colors.blue[200]!, Colors.blue[300]!],
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