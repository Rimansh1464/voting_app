import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helper/colud_firebase_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Voting App"),
        backgroundColor: Colors.redAccent,
        actions: [IconButton(onPressed: (){            Navigator.pushNamed(context, 'showVote');
        }, icon: const Icon(Icons.add_chart))],
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
                    return ListView.builder(
                      itemCount: queryDocumentSnapshot.length,
                      itemBuilder: (context, i) {
                        Map<String, dynamic> data = queryDocumentSnapshot[i]
                            .data() as Map<String, dynamic>;

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
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${data['name']}",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Spacer(),

                                    InkWell(
                                      onTap: (){
                                        CloudFireStoreHelper
                                            .cloudFireStoreHelper
                                            .updateData(
                                          id: queryDocumentSnapshot[i].id,
                                          voting:
                                          int.parse("${data["vote"]}") + 1,
                                        );
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 70,
                                        child: Center(child: Text("Vote",style: TextStyle(color: Colors.white),),),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.redAccent),
                                      ),
                                    )
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
}
