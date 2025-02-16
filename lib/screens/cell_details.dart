import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monitor_mobile_app/widgets/humidity_chart.dart';
import 'package:monitor_mobile_app/widgets/temperature_chart.dart';
import 'package:monitor_mobile_app/utils/models.dart';

List<String> list = HistoryTimeOption.values.map((e) => e.value).toList();

class ChartData {
  ChartData(this.time, this.value);
  final int time;
  final double value;
}

typedef MenuEntry = DropdownMenuEntry<String>;

class DetailPage extends StatefulWidget {
  final int index;
  final CellData cellData;

  const DetailPage({
    super.key,
    required this.index,
    required this.cellData,
  });
  
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    list.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );
  
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cell ${widget.index + 1}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                DropdownMenu<String>(
                  width: 165,
                  textStyle: TextStyle(fontSize: 16),
                  initialSelection: settings.historyTimeOption,
                  onSelected: (String? value) {
                    setState(() {
                      settings.setHistoryTimeOption(value!);
                    });
                  },
                  dropdownMenuEntries: menuEntries,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              spacing: 8,
              children: [
                Text(
                  "VOC ${widget.cellData.vocDetected ? 'detected' : 'not detected'}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                SvgPicture.asset(
                  !widget.cellData.vocDetected ? 'assets/icons/shield-check.svg' : 'assets/icons/shield-x.svg',
                  colorFilter: ColorFilter.mode(
                    !widget.cellData.vocDetected ? Colors.green : Colors.red, 
                    BlendMode.srcIn
                  ),
                )
              ],
            ),
            const SizedBox(height: 28),
            HumidityChart(humiditys: widget.cellData.humidity,),
            const SizedBox(height: 24),
            TemperatureChart(temperatures: widget.cellData.temperature,),
          ],
        ),
      ),
    );
  }
}
