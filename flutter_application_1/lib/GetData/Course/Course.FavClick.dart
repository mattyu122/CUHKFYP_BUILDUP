import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/GetData/Course/C_Provider.dart';
import 'package:flutter_application_1/GetData/Course/Course_Sreen_details.dart';
import 'package:flutter_application_1/services/Firebase_service.dart';
import 'package:provider/provider.dart';

class FAVc extends StatefulWidget {
  const FAVc({super.key});

  @override
  State<FAVc> createState() => _FAVcState();
}

class _FAVcState extends State<FAVc> {
  Widget build(BuildContext context) {
    var _provider = Provider.of<CpostProvider>(context);
    FirebaseService _service = FirebaseService();

    return Center(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              _service.Cpost.where('favc', arrayContains: _service.user?.uid)
                  .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("");
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                child: Container(
                  height: 750,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              var doc = snapshot.data?.docs[index];
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                // height: 80,
                                // width: 90,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _provider.getCpostDetails(doc);
                                        Navigator.pushNamed(
                                            context, CourseSreenDetails.id);
                                      },
                                      child: Container(
                                        width: 400,
                                        height: 290,
                                        margin: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              spreadRadius: 1,
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              child: Image.network(
                                                  doc!['PostP'],
                                                  height: 200,
                                                  width: 400,
                                                  fit: BoxFit.cover),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 12, 8, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${doc['PostN']}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    textDirection:
                                                        TextDirection.ltr,
                                                  ),
                                                  // SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Exp : ${doc['PostD']}',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        child: TextButton(
                                                          onPressed: () {},
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.favorite,
                                                                color: Colors
                                                                    .deepPurple,
                                                              ),
                                                              Text(
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .deepPurple,
                                                                    // fontSize: 13,
                                                                    // fontWeight:
                                                                    //     FontWeight
                                                                    //         .w500,
                                                                  ),
                                                                  '   ${doc['PostL']}'
                                                                      .toString()),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
