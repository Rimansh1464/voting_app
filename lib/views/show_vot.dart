import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../helper/colud_firebase_helper.dart';

class showVote extends StatefulWidget {
  const showVote({Key? key}) : super(key: key);

  @override
  State<showVote> createState() => _showVoteState();
}

class _showVoteState extends State<showVote> {
  @override
  late TooltipBehavior _tooltipBehavior;

  void initState() {
    super.initState();
    _tooltipBehavior =  TooltipBehavior(enable: true);

  }
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: CloudFireStoreHelper.cloudFireStoreHelper.fetchData(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> queryDocumentSnapshot =
                  querySnapshot.docs;

              Map<String, dynamic> data1 =
                  queryDocumentSnapshot[0].data() as Map<String, dynamic>;
              Map<String, dynamic> data2 =
                  queryDocumentSnapshot[1].data() as Map<String, dynamic>;
              Map<String, dynamic> data3 =
                  queryDocumentSnapshot[2].data() as Map<String, dynamic>;
              Map<String, dynamic> data4 =
                  queryDocumentSnapshot[3].data() as Map<String, dynamic>;

              return Center(
                  child: Container(
                child: SfCircularChart(
                  // Enables the legend
                    legend: Legend(isVisible: true,textStyle: TextStyle(fontSize: 18),backgroundColor:Colors.grey[200],position:LegendPosition.bottom,  ),
                    series: <CircularSeries>[
                      PieSeries<ChartData, String>(
                          dataSource: [
                            ChartData('BJP', int.parse("${data1["vote"]}")),
                            ChartData('AAP', int.parse("${data2["vote"]}")),
                            ChartData(
                                'Congress', int.parse("${data3["vote"]}")),
                            ChartData(
                                'BSP', int.parse("${data4["vote"]}")),
                          ],
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          dataLabelSettings:DataLabelSettings(isVisible : true,textStyle: TextStyle(fontSize: 20),),


                          name: 'Data'
                      )
                    ]
                ),
//                 SfCartesianChart(
//                     primaryXAxis: CategoryAxis(),
//                     title: ChartTitle(text: 'total votes'),
//                     legend: Legend(isVisible: true),
//                     tooltipBehavior: TooltipBehavior(enable: true),
//                     series: <ChartSeries<ChartData, String>>[
//                       LineSeries<ChartData, String>(
//
//                           dataSource: [
//                             ChartData('BJP', double.parse("${data1["vote"]}")),
//                             ChartData('AAP', double.parse("${data2["vote"]}")),
//                             ChartData(
//                                 'Congress', double.parse("${data3["vote"]}")),
//                             ChartData(
//                                 'BSP', double.parse("${data4["vote"]}")),
//                             // ChartData('Congress', "${data["vote"]}"),
//                           ],
//                           xValueMapper: (ChartData sales, _) => sales.x,
//                           yValueMapper: (ChartData sales, _) => sales.y,
//                           color: Colors.red,
// width: 2,
//                           dataLabelSettings: DataLabelSettings(isVisible: true))
//                     ]),
              ));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final int y;
}
// Center(
// child: Container(
// child:SfCartesianChart(
// primaryXAxis: CategoryAxis(),
// // Chart title
// title: ChartTitle(text: 'total'),
//
// // Enable legend
// legend: Legend(isVisible: true),
// // Enable tooltip
// tooltipBehavior: TooltipBehavior(enable: true),
// series: <ChartSeries<ChartData, String>>[
// LineSeries<ChartData, String>(
// dataSource: [
// ChartData('BJP', 10),
// ChartData('AAP', 28),
// ChartData('Mar', 34),
// ChartData('Apr', 32),
// ChartData('May', 40)
// ],
// xValueMapper: (ChartData sales, _) => sales.x,
// yValueMapper: (ChartData sales, _) => sales.y,
// name: 'Sales',
// // Enable data label
// dataLabelSettings: DataLabelSettings(isVisible: true))
// ]),
// )
// )
