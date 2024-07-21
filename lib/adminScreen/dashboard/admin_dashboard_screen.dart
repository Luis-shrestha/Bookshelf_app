import 'package:flutter/material.dart';
import '../../userScreen/model/repository/upload_repo/fetch_data.dart';
import '../constants.dart';
import '../responsive.dart';
import 'components/header.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key,});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

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
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        /*MyFiles(),*/
                        SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context)) StorageDetails(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: defaultPadding),
                  // On Mobile means if the screen is less than 850 we don't want to show it
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 2,
                      child: StorageDetails(),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
