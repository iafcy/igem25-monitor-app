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
  List<CellData>? _cellData;
  final GridService _gridService = GridService();

  Future<void> _connect() async {
    setState(() {_isConnecting = true;});
    
    List<CellData> fetchedData = await _gridService.fetchGridData();

    setState(() {
      _isConnecting = false;
      _isConnected = true;
      _cellData = fetchedData;
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
    final bool cardsReady = _isConnected && _cellData != null;
    int n_detected = _cellData?.where((cell) => cell.vocDetected).length ?? 9;
    int n_lowGM = _cellData?.where((cell) => cell.remainingGM < 0.25).length ?? 0;
    
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
                      cellData: cardsReady ? _cellData![index] : null,
                      onPressed: cardsReady
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    index: index,
                                    cellData: _cellData![index],
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
                      backgroundColor: Colors.blue,
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
                    const Text(
                      "Overview",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
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
                          '$n_detected cells',
                          style: TextStyle(
                            fontSize: 20,
                            color: n_detected > 0 ? Colors.red[800] : Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "≤ 25% of GM Bacteria",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "$n_lowGM cells",
                          style: TextStyle(
                            fontSize: 20,
                            color: n_lowGM > 0 ? Colors.red[800] : Colors.green[800],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            if (_isConnected)
              Center(
                child: ElevatedButton(
                  onPressed: _isConnecting ? null : _disconnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
