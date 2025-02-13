import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monitor_mobile_app/utils/models.dart';

class GridCellCard extends StatelessWidget {
  final int index;
  final bool isReady;
  final CellData? cellData;
  final VoidCallback? onPressed;

  const GridCellCard({
    super.key,
    required this.index,
    required this.isReady,
    this.cellData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    if (!isReady) {
      cardColor = Colors.grey[400]!;
    } else {
      bool vocDetected = cellData!.vocDetected;
      cardColor = !vocDetected ? Colors.green[400]! : Colors.red[400]!;
    }

    return FilledButton(
      onPressed: isReady ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: !isReady ? Container() : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          SvgPicture.asset(
            width: 32,
            height: 32,
            !cellData!.vocDetected ? 'assets/icons/shield-check.svg' : 'assets/icons/shield-x.svg',
            colorFilter: ColorFilter.mode(
              !cellData!.vocDetected ? Colors.green[900]! : Colors.red[900]!, 
              BlendMode.srcIn
            ),
          ),
          LinearProgressIndicator(
            value: cellData!.remainingGM,
            minHeight: 6,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            backgroundColor: !cellData!.vocDetected ? Colors.green[200]! : Colors.red[200]!, 
            color: !cellData!.vocDetected ? Colors.green[800]! : Colors.red[800]!, 
          ),
        ],
      ),
    );
  }
}
