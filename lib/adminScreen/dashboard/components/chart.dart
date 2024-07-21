import 'package:flutter/material.dart';

import '../../../userScreen/model/repository/upload_repo/fetch_data.dart';
import 'customPiewChart.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final FetchData fetchData = FetchData();
  late Future<Map<String, List<Map<String, dynamic>>>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData.fetchAndGroupData();
  }

  Future<void> _refreshData() async {
    setState(() {
      dataFuture = fetchData.fetchAndGroupData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          final groupedData = snapshot.data!;
          final pieChartData = groupedData.entries.map((entry) {
            return {
              'category': entry.key,
              'amount': entry.value.length.toDouble(),
            };
          }).toList();

          // Define a list of colors
          final List<Color> colors = [
            Colors.redAccent,
            Colors.blueAccent,
            Colors.greenAccent,
            Colors.yellowAccent,
            Colors.purpleAccent,
            Colors.orangeAccent,
            Colors.lightBlueAccent,
            Colors.lightBlue,
          ];

          return SizedBox(
            height: 300,
            child: CustomPieChart(
              data: pieChartData,
              colors: colors,
              title: 'Book Categories',
            ),
          );
        }
      },
    );
  }
}
