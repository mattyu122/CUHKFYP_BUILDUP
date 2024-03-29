// ignore_for_file: prefer_const_constructors, unnecessary_new
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/GetData/Event/Event_CatSreen.dart';
import 'package:flutter_application_1/services/Firebase_service.dart';
import 'package:flutter_application_1/GetData/Event/Event_Cat/DramaSreen.dart';
import 'package:flutter_application_1/GetData/Event/Event_Cat/FoodSreen.dart';
import 'package:flutter_application_1/GetData/Event/Event_Cat/GameScreen.dart';
import 'package:flutter_application_1/GetData/Event/Event_Cat/MovieSreen.dart';
import 'package:flutter_application_1/GetData/Event/Event_Cat/MusicSreen.dart';
import 'package:flutter_application_1/GetData/Event/Event_Cat/PartySreen.dart';
import 'package:flutter_application_1/GetData/Event/Event_Cat/PhotoSreen.dart';
import 'package:flutter_application_1/GetData/Event/Event_Cat/ReadSreen.dart';
import 'package:flutter_application_1/GetData/Event/Event_Cat/SingSreen.dart';
import 'package:flutter_application_1/GetData/Event/Event_Cat/SportSreen.dart';

class EventCat extends StatefulWidget {
  const EventCat({super.key});

  @override
  State<EventCat> createState() => _EventCatState();
}

class _EventCatState extends State<EventCat> {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Center(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _service.cat.snapshots(),
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
                height: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          ' Categories',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        )),
                        Container(
                          height: 32,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, EventCatSreen.id);
                            },
                            child: Row(
                              children: const [
                                Text('See All ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    )),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Colors.white,
                                )
                              ],
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
                              height: 100,
                              width: 91,
                              child: Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, doc!['sreenid']);
                                      },
                                      child: Image.network(doc!['catP'])),
                                  Flexible(
                                      child: Text(
                                    doc['catN'],
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ))
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
