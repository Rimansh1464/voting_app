import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/provider/vote_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/colud_firebase_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  @override

  defaultData() {
    Provider.of<voteProvider>(context, listen: false).savevote();
  }
  @override
  void initState() {
    super.initState();
    defaultData();
  }

  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: const Text("Voting App"),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'showVote');
              },
              icon: const Icon(Icons.add_chart))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: CloudFireStoreHelper.cloudFireStoreHelper.fetchData(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<QueryDocumentSnapshot> queryDocumentSnapshot =
                        querySnapshot.docs;
                    Map<String, dynamic> data = queryDocumentSnapshot[0].data() as Map<String, dynamic>;


                    return ListView.builder(
                      itemCount: queryDocumentSnapshot.length,
                      itemBuilder: (context, i) {
                        Map<String, dynamic> data = queryDocumentSnapshot[i].data() as Map<String, dynamic>;

                        return Container(
                          margin: const EdgeInsets.all(5),
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(blurRadius: 5, color: Colors.black12)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${data['name']}",

                                      style: const TextStyle(fontSize: 30),
                                    ),
                                    Spacer(),
                                    (Provider.of<voteProvider>(context).vot == false)?
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Text("Party: ${data['name']}"),
                                                  SizedBox(height: 10,),
                                                  const Text(
                                                    "You are confirm to vote for this party",
                                                    style: TextStyle(fontSize: 15),
                                                  ),
                                                ],
                                              ),

                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () async {

                                                    SharedPreferences prefs = await SharedPreferences.getInstance();

                                                    setState(()  {

                                                      prefs.setBool('vot', true);

                                                      CloudFireStoreHelper
                                                          .cloudFireStoreHelper
                                                          .updateData(
                                                        id: queryDocumentSnapshot[i]
                                                            .id,
                                                        voting: int.parse(
                                                            "${data["vote"]}") +
                                                            1,

                                                      );
                                                      print("${ Provider.of<voteProvider>(context,listen: false).savevote()}");

                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  style:
                                                  ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                      Colors.redAccent),
                                                  child: const Text("Confirm"),
                                                ),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("cancel"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 70,
                                        child: Center(
                                          child: Text(
                                            "Vote",
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            color: Colors.redAccent),
                                      ),
                                    ):
                                    InkWell(
                                      onTap: () {
                                        print("${ Provider.of<voteProvider>(context,listen: false).vot}");

                                        showDialog(

                                          context: context,
                                          builder: (context) {
                                            return Center(
                                              child: Container(
                                                height: 200,
                                                width: 280,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 10,),

                                                    Image.asset("asserts/image/error.png",scale: 5,),
                                                    Text("Sorry",style: TextStyle(color: Colors.black,fontSize: 25),),
                                                    SizedBox(height: 20,),
                                                    Text("You can once.No Second time",style: TextStyle(color: Colors.black,fontSize: 20),),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 70,
                                        child: Center(
                                          child: Text(
                                            "Vote",
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 30,
                                  thickness: 2,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  CommonContainer(
      {required String Partyname, required String id, required vote}) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)]),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  // "${data['name']}",
                  Partyname,
                  style: const TextStyle(fontSize: 30),
                ),
                Spacer(),
                (false == false)
                    ? InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Party: ${Partyname}"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "You are confirm to vote for this party",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      setState(() {
                                        prefs.setBool('vot', true);

                                        CloudFireStoreHelper
                                            .cloudFireStoreHelper
                                            .updateData(
                                          id: id,
                                          // queryDocumentSnapshot[i].id,
                                          voting: int.parse("${vote}") + 1,
                                        );
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent),
                                    child: const Text("Confirm"),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("cancel"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.redAccent),
                          child: const Center(
                            child: Text(
                              "Vote",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            const Divider(
              height: 30,
              thickness: 2,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
// Container(
// margin: const EdgeInsets.all(5),
// width: double.infinity,
// height: 100,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// color: Colors.white,
// boxShadow: const [
// BoxShadow(blurRadius: 5, color: Colors.black12)
// ]),
// child: Padding(
// padding: const EdgeInsets.all(15),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// children: [
// SizedBox(
// width: 10,
// ),
// Text(
// // "${data['name']}",
// Partyname,
// style: const TextStyle(fontSize: 30),
// ),
// Spacer(),
// (vot == false)?
// InkWell(
// onTap: () {
// showDialog(
// context: context,
// builder: (context) {
// return AlertDialog(
// title: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
//
// Text("Party: ${Partyname}"),
// SizedBox(height: 10,),
// Text(
// "You are confirm to vote for this party",
// style: TextStyle(fontSize: 15),
// ),
// ],
// ),
//
// actions: [
// ElevatedButton(
// onPressed: () async {
//
// SharedPreferences prefs = await SharedPreferences.getInstance();
//
// setState(()  {
//
// prefs.setBool('vot', true);
//
// CloudFireStoreHelper
//     .cloudFireStoreHelper
//     .updateData(
// id: queryDocumentSnapshot[i]
//     .id,
// voting: int.parse(
// "${data["vote"]}") +
// 1,
// );
// });
// Navigator.of(context).pop();
// },
// style:
// ElevatedButton.styleFrom(
// backgroundColor:
// Colors.redAccent),
// child: const Text("Confirm"),
// ),
// OutlinedButton(
// onPressed: () {
// Navigator.of(context).pop();
// },
// child: const Text("cancel"),
// ),
// ],
// );
// },
// );
// },
// child: Container(
// height: 40,
// width: 70,
// child: Center(
// child: Text(
// "Vote",
// style:
// TextStyle(color: Colors.white),
// ),
// ),
// decoration: BoxDecoration(
// borderRadius:
// BorderRadius.circular(10),
// color: Colors.redAccent),
// ),
// ):Container(),
// ],
// ),
// const Divider(
// height: 30,
// thickness: 2,
// color: Colors.black,
// ),
// ],
// ),
// ),
// );




// Column(
// children: [
// CommonContainer(
// Partyname: '${data["name"]}',
// id: '${queryDocumentSnapshot[0].id}',
// vote: int.parse("${data["vote"]}"),
// ),
// CommonContainer(
// Partyname: '${data1["name"]}',
// id: '${queryDocumentSnapshot[1].id}',
// vote: int.parse("${data1["vote"]}"),
// ),
// CommonContainer(
// Partyname: '${data2["name"]}',
// id: '${queryDocumentSnapshot[2].id}',
// vote: int.parse("${data2["vote"]}"),
// ),
// CommonContainer(
// Partyname: '${data3["name"]}',
// id: '${queryDocumentSnapshot[3].id}',
// vote: int.parse("${data3["vote"]}"),
// ),
// ],
// );