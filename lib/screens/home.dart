import 'package:flutter/material.dart';
import 'package:monitor_mobile_app/utils/models.dart';
import 'package:monitor_mobile_app/data/cell_service.dart';
import 'package:monitor_mobile_app/widgets/appbar.dart';
import 'package:monitor_mobile_app/widgets/grid_cell_card.dart';
import 'cell_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isConnecting = false;
  bool _isConnected = false;
  SensorData? _data;
  final DataService _gridService = DataService();

  Future<void> _connect() async {
    setState(() {_isConnecting = true;});
    
    SensorData fetchedData = await _gridService.fetchData();

    setState(() {
      _isConnecting = false;
      _isConnected = true;
      _data = fetchedData;
    });
  }

  Future<void> _disconnect() async {
    setState(() {_isConnecting = true;});
    
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isConnecting = false;
      _isConnected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool cardsReady = _isConnected && _data != null;
    int nDetected = _data?.grid.where((cell) => cell.vocDetected).length ?? 9;
    
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 48),
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: List.generate(9, (index) {
                    return GridCellCard(
                      index: index,
                      isReady: cardsReady,
                      cellData: cardsReady ? _data!.grid[index] : null,
                      onPressed: cardsReady
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    index: index,
                                    cellData: _data!.grid[index],
                                  ),
                                ),
                              );
                            }
                          : null,
                    );
                  }),
                ),
                if (_isConnecting)
                  const SizedBox(
                    height: 56,
                    width: 56,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 6,
                    ),
                  ),
              ],
            ),
            if (!_isConnected)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: ElevatedButton(
                    onPressed: _isConnecting ? null : _connect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff226554),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      'Connect',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            if (_isConnected)
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'VOC detected',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$nDetected cells',
                          style: TextStyle(
                            fontSize: 20,
                            color: nDetected > 0 ? Colors.red[800] : Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                          "${(_data!.remainingGM * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 750),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                          begin: 0,
                          end: _data!.remainingGM,
                      ),
                      builder: (context, value, _) =>
                          LinearProgressIndicator(
                            value: value,
                            minHeight: 12,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Color(0xff226554),
                            backgroundColor: Color(0xbf51ad95),
                          ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            if (_isConnected)
              Center(
                child: ElevatedButton(
                  onPressed: _isConnecting ? null : _disconnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff51ad95),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text(
                    'Disconnect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
