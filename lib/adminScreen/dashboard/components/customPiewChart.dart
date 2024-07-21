import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomPieChart extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final List<Color> colors;
  final String title;

  const CustomPieChart({
    Key? key,
    required this.data,
    required this.colors,
    required this.title,
  }) : super(key: key);

  @override
  _CustomPieChartState createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.data.fold(0, (sum, item) => sum + item['amount']);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 250,
        child: Stack(
          children: [
            PieChart(
              PieChartData(
                sections: widget.data.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> data = entry.value;
                  final value = (data['amount'] / totalAmount) * _animation.value * 100;
                  return PieChartSectionData(
                    color: widget.colors[index % widget.colors.length],
                    value: value,
                    radius: 20,
                    title: '',
                  );
                }).toList(),
                sectionsSpace: 0,
                centerSpaceRadius: 100,
                startDegreeOffset: -90,
              ),
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
                  Text("${totalAmount.toString()} items",
                      style: const TextStyle(fontSize: 16,color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
