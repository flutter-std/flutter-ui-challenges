import 'package:c004_covid19_dashboard/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CovidCard extends StatelessWidget {
  final DataPoint dataPoint;
  final int value;
  const CovidCard({super.key, required this.dataPoint, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 28, 26, 31),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dataPoint.name,
              style: TextStyle(color: dataPoint.color, fontSize: 24),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  dataPoint.assetPath,
                  color: dataPoint.color,
                ),
                Text(
                  NumberFormat.decimalPattern().format(value),
                  style: TextStyle(
                    color: dataPoint.color,
                    fontSize: 30,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
