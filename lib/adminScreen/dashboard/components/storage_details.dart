import 'package:flutter/material.dart';
import '../../../userScreen/model/repository/upload_repo/fetch_data.dart';
import '../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';
import '../../../../utility/constant/constant.dart' as constant;

class StorageDetails extends StatefulWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<StorageDetails> createState() => _StorageDetailsState();
}

class _StorageDetailsState extends State<StorageDetails> {
  final FetchData fetchData = FetchData();
  late Future<Map<String, List<Map<String, dynamic>>>> dataFuture;

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
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: constant.kBackGroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Books Details",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600, color: Colors.black
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
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
                int colorIndex = 0;
                return Column(
                  children: groupedData.entries.map((entry) {
                    final category = entry.key;
                    final books = entry.value;
                    final color = colors[colorIndex % colors.length];
                    colorIndex++;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StorageInfoCard(
                          svgSrc: "assets/adminSide/icons/Documents.svg",
                          title: category,
                          numOfFiles: books.length,
                          color: color,
                        ),
                      ],
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
