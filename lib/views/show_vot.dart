import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 0,
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('vot', false);
          },
          child: Icon(Icons.add_circle_outline),
        ),
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
                  child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 410,
                  width: 400,
                  child: SfCircularChart(
                      // Enables the legend
                      legend: Legend(
                        isVisible: true,
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.grey[200],
                        position: LegendPosition.top,
                      ),
                      series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                            dataSource: [
                              ChartData('BJP', int.parse("${data1["vote"]}")),
                              ChartData('AAP', int.parse("${data2["vote"]}")),
                              ChartData(
                                  'Congress', int.parse("${data3["vote"]}")),
                              ChartData('BSP', int.parse("${data4["vote"]}")),
                            ],

                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            dataLabelSettings: DataLabelSettings(

                              isVisible: true,
                              textStyle: TextStyle(fontSize: 23),
                            ),
                            name: 'Data')
                      ]),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xff75a4cc)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${data1["name"]}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                                Text("vote: ${data1["vote"]}",style: TextStyle(fontSize: 20),),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffc06c84)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${data2["name"]}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                                Text("vote: ${data2["vote"]}",style: TextStyle(fontSize: 20),),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xfff67280)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${data3["name"]}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                                Text("vote: ${data3["vote"]}",style: TextStyle(fontSize: 20),),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xfff8b195)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${data4["name"]}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                                Text("vote: ${data4["vote"]}",style: TextStyle(fontSize: 20),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]));
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
