import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monitor_mobile_app/widgets/humidity_chart.dart';
import 'package:monitor_mobile_app/widgets/temperature_chart.dart';
import 'package:monitor_mobile_app/utils/models.dart';

class ChartData {
  ChartData(this.time, this.value);
  final int time;
  final double value;
}

class DetailPage extends StatelessWidget {
  final int index;
  final CellData cellData;
  
  const DetailPage({
    super.key,
    required this.index,
    required this.cellData,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Cell ${index + 1}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 24),
            Row(
              spacing: 8,
              children: [
                Text(
                  "VOC ${cellData.vocDetected ? 'detected' : 'not detected'}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                SvgPicture.asset(
                  !cellData.vocDetected ? 'assets/icons/shield-check.svg' : 'assets/icons/shield-x.svg',
                  colorFilter: ColorFilter.mode(
                    !cellData.vocDetected ? Colors.green : Colors.red, 
                    BlendMode.srcIn
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Remaining GM Bacteria",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "${(cellData.remainingGM * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 750),
                  // curve: Curves.easeInOut,
                  tween: Tween<double>(
                      begin: 0,
                      end: cellData.remainingGM,
                  ),
                  builder: (context, value, _) =>
                      LinearProgressIndicator(
                        value: value,
                        minHeight: 12,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        backgroundColor: Colors.grey[300],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            HumidityChart(humiditys: cellData.humidity,),
            const SizedBox(height: 24),
            TemperatureChart(temperatures: cellData.temperature,),
          ],
        ),
      ),
    );
  }
}
