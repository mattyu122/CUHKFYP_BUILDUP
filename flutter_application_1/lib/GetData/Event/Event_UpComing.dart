import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/GetData/Event/Event_Sreen_details.dart';
import 'package:flutter_application_1/GetData/Event/Provider.dart';
import 'package:flutter_application_1/GetData/Event/Read1.dart';
import 'package:flutter_application_1/services/Firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/GetData/Event/ReadUser.dart';
import 'package:flutter_application_1/DataModel/userAccount.dart';
import 'package:flutter_application_1/GetData/Event/Read1.dart';

class EventUP extends StatefulWidget {
  const EventUP({super.key});

  @override
  State<EventUP> createState() => _EventUPState();
}

class _EventUPState extends State<EventUP> {
  @override
  void initState() {
    super.initState();
    // fetchRecords();
    fetchUserInfo2();
  }

  UserAccount? currentUserInfo;

  Future fetchUserInfo2() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
            (value) => {currentUserInfo = UserAccount.fromMap(value.data()!)});
  }

  Widget build(BuildContext context) {
    var _provider = Provider.of<EpostProvider>(context);
    FirebaseService _service = FirebaseService();

    return Center(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _service.post
              .where('gender', isEqualTo: currentUserInfo?.gender)
              .where('faculty', isEqualTo: currentUserInfo?.faculty)
              .where('eventType', isEqualTo: currentUserInfo?.interestEvent)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
              child: Container(
                height: 228,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          ' Recommend',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        )),
                        SizedBox(
                          height: 32,
                          child: TextButton(
                            onPressed: () {},
                            child: Row(
                                // children: const [
                                //   Text('See All',
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 15.0,
                                //       )),
                                //   Icon(
                                //     Icons.arrow_forward_ios,
                                //     size: 12,
                                //     color: Colors.white,
                                //   )
                                // ],
                                ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var doc = snapshot.data?.docs[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              // height: 80,
                              // width: 90,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _provider.getEpostDetails(doc);
                                      Navigator.pushNamed(
                                          context, EventSreenDetails.id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRect(
                                        child: Image.network(
                                          doc!['PostP'],
                                          height: 180,
                                          width: 300,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )

                                  // Flexible(
                                  //     child: Text(
                                  //   doc['PostN'],
                                  //   maxLines: 2,
                                  //   textAlign: TextAlign.center,
                                  // ))
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
