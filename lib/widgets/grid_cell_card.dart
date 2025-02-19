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
      cardColor = !vocDetected ? Color(0xff51ad95) : Colors.red[400]!;
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
              !cellData!.vocDetected ? Color(0xff226554) : Colors.red[900]!, 
              BlendMode.srcIn
            ),
          ),
        ],
      ),
    );
  }
}
