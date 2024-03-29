// ignore_for_file: prefer_const_constructors, unnecessary_new
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/DataModel/userAccount.dart';
import 'package:flutter_application_1/DrawerPages/Setting.dart';
import 'package:flutter_application_1/HomePages/Home.dart' as selfCreated;
import 'package:flutter_application_1/services/Firebase_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String dropdownvalue1 = 'Select Your Faculty';
  var items1 = [
    'Select Your Faculty',
    'Medicine',
    'Science',
    'Engine',
    'Social Science',
    'Arts',
    'Business',
    'Education',
    'Law',
  ];
  String dropdownvalue3 = 'Select Your Interest Event';
  var items3 = [
    'Select Your Interest Event',
    'Social event',
    'Educational event',
    'Entertainment event',
    'Sports and fitness event',
    'Outdoor event',
    'Relaxation event',
    'Cultural event',
    'Food and drink event',
    'Charity event',
    'Gaming event',
    'Competition event',
    'Other events'
  ];

  String dropdownvalue4 = 'Select Your Tag';
  var items4 = [
    'Select Your Tag',
    'Hardworking groupmate',
    'Perfectionist groupmate',
    'Leader groupmate',
    'Collaborative groupmate',
  ];
  late final UserAccount currentUserInfo;
  bool saved = false;
  int selected = 0;
  final nameController = TextEditingController();
  final majorController = TextEditingController();
  final introductionController = TextEditingController();
  final tagsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseStorage storage = FirebaseStorage.instance;
  String profilePhotoURL = "";
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final destination = FirebaseAuth.instance.currentUser!.uid;

    try {
      final ref =
          FirebaseStorage.instance.ref(destination).child('profilePhoto/');
      await ref.putFile(_photo!);
      //await fetchUserInfo();
      final profilePhotoURLtmp = await FirebaseStorage.instance
          .ref(FirebaseAuth.instance.currentUser!.uid)
          .child('profilePhoto')
          .getDownloadURL();
      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({"profileImageUrl": profilePhotoURLtmp});
      print(profilePhotoURL);
    } catch (e) {
      print('error occured');
    }
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      print('object');
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'userName': nameController.text.trim(),
        'major': majorController.text.trim(),
        'introduction': introductionController.text.trim(),
        'gender': selected == 1
            ? "Male"
            : selected == 2
                ? "Female"
                : selected == 3
                    ? "Male/Female/Other"
                    : "",
        'tags': tagsController.text.trim(),
        'faculty': dropdownvalue1,
        'interestEvent': dropdownvalue3,
        'groupMateTag': dropdownvalue4,
      }).then((value) => setState(() {
                saved = true;
              }));
    }
  }

  Widget customRadio(String text, int index, final text2) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selected = index;
        });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(100, 100),
        backgroundColor: (selected == index)
            ? Color.fromARGB(255, 240, 69, 240)
            : Color.fromARGB(255, 224, 154, 241),
      ),
      child: Column(
        children: [
          Icon(
            text2,
            size: 67,
            color: (selected == index)
                ? Colors.black
                : Color.fromARGB(255, 255, 255, 255),
          ),
          Text(
            text,
            style: TextStyle(
                color: (selected == index)
                    ? Colors.black
                    : Color.fromARGB(255, 255, 255, 255),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future fetchUserInfo() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
            (value) => {currentUserInfo = UserAccount.fromMap(value.data()!)});

    // final profilePhotoURLtmp = await FirebaseStorage.instance
    //     .ref(FirebaseAuth.instance.currentUser!.uid)
    //     .child('profilePhoto')
    //     .getDownloadURL();
    setState(() {
      nameController.text = currentUserInfo.userName;
      majorController.text = currentUserInfo.major ?? '';
      introductionController.text = currentUserInfo.introduction ?? '';
      tagsController.text = currentUserInfo.tags ?? '';
      selected = (currentUserInfo.gender == "Male"
          ? 1
          : currentUserInfo.gender == "Female"
              ? 2
              : currentUserInfo.gender == "Other"
                  ? 3
                  : 0);
      profilePhotoURL = currentUserInfo.profileImageUrl!;
      dropdownvalue1 = currentUserInfo.faculty!;
      dropdownvalue3 = currentUserInfo.interestEvent!;
      dropdownvalue4 = currentUserInfo.groupMateTag!;
    });
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: selfCreated.NavigationDrawer(),
        appBar: new AppBar(
          backgroundColor: Color.fromARGB(255, 119, 20, 244),
          iconTheme: IconThemeData(
              color: Color.fromARGB(255, 255, 255, 255), size: 30),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SetPage(),
                ));
              },
              icon: Icon(
                Icons.settings,
              ),
            )
          ],
          title: Text('PROFILE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              )),
          toolbarHeight: 56,
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Center(
                    child: InkWell(
                      splashColor: Colors.blue,
                      borderRadius: BorderRadius.circular(150.0),
                      // customBorder: CircleBorder(),
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(profilePhotoURL),
                            )),
                      ),
                    ),
                  ),

                  // Positioned(
                  //     bottom: 0,
                  //     right: 0,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: Icon(
                  //         Icons.edit,
                  //         color: Colors.white,
                  //       ),
                  //     )),

                  SizedBox(
                    height: 10,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          FirebaseAuth.instance.currentUser!.email!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Container(),
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                              // color: Colors.black,
                              // border: Border.all(
                              //     color: Color.fromARGB(255, 181, 156, 255),
                              //     width: 2),
                              // borderRadius: BorderRadius.circular(10.0),
                              ),
                          child: TextFormField(
                              controller: nameController,
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  filled: true, //<-- SEE HERE
                                  fillColor: Color.fromARGB(255, 181, 156, 255),
                                  constraints: BoxConstraints.tightFor(
                                      width: 380, height: 65),
                                  // labelText: 'Description',
                                  // labelStyle: TextStyle(
                                  //   color: Colors.white,
                                  //   fontWeight: FontWeight.bold,
                                  // ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 181, 156, 255),
                                          width: 2)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 119, 20, 244),
                                          width: 2)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please complete required field';
                                }
                                return null;
                              }),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'Major',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                              // color: Colors.black,
                              // border: Border.all(
                              //     color: Color.fromARGB(255, 181, 156, 255),
                              //     width: 2),
                              // borderRadius: BorderRadius.circular(10.0),
                              ),
                          child: TextFormField(
                              controller: majorController,
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  filled: true, //<-- SEE HERE
                                  fillColor: Color.fromARGB(255, 181, 156, 255),
                                  constraints: BoxConstraints.tightFor(
                                      width: 380, height: 60),
                                  // labelText: 'Description',
                                  // labelStyle: TextStyle(
                                  //   color: Colors.white,
                                  //   fontWeight: FontWeight.bold,
                                  // ),

                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 181, 156, 255),
                                          width: 2)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 119, 20, 244),
                                          width: 2)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2))),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please complete required field';
                                }
                                return null;
                              }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: TextFormField(
                            controller: introductionController,
                            maxLines: 30,
                            style: TextStyle(fontSize: 17, color: Colors.black),
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 10),
                                filled: true, //<-- SEE HERE
                                fillColor: Color.fromARGB(255, 181, 156, 255),
                                constraints: BoxConstraints.tightFor(
                                    width: 380, height: 200),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 181, 156, 255),
                                        width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 119, 20, 244),
                                        width: 2)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2))),
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Please complete required flied';
                            //   }
                            //   return null;
                            // }
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Select Your Gender',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Container(),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         Expanded(
                  //             child: ElevatedButton(
                  //                 onPressed: () {}, child: Text("MALE"))),
                  //         SizedBox(
                  //           width: 20,
                  //         ),
                  //         Expanded(
                  //             child: ElevatedButton(
                  //                 onPressed: () {}, child: Text("FEMALE"))),
                  //         SizedBox(
                  //           width: 20,
                  //         ),
                  //         Expanded(
                  //             child: ElevatedButton(
                  //                 onPressed: () {}, child: Text("OTHER"))),
                  //       ]),
                  // ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        customRadio("Male", 1, Icons.male),
                        SizedBox(
                          width: 20,
                        ),
                        customRadio("Female", 2, Icons.female),
                        SizedBox(
                          width: 20,
                        ),
                        customRadio("Other", 3, Icons.transgender)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'Faculty of Major',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: Color.fromARGB(255, 181, 156, 255)),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          width: 380,
                          height: 60,
                          child: DropdownButton(
                            isExpanded: true,
                            underline: Container(),
                            dropdownColor: Colors.black,
                            value: dropdownvalue1,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Color.fromARGB(255, 181, 156, 255)),
                            items: items1.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue1) {
                              setState(() {
                                dropdownvalue1 = newValue1!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'Event type of interest',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: Color.fromARGB(255, 181, 156, 255)),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          width: 380,
                          height: 60,
                          child: DropdownButton(
                            isExpanded: true,
                            underline: Container(),
                            dropdownColor: Colors.black,
                            value: dropdownvalue3,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Color.fromARGB(255, 181, 156, 255)),
                            items: items3.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue3) {
                              setState(() {
                                dropdownvalue3 = newValue3!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'Course Tag',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: Color.fromARGB(255, 181, 156, 255)),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          width: 380,
                          height: 60,
                          child: DropdownButton(
                            isExpanded: true,
                            underline: Container(),
                            dropdownColor: Colors.black,
                            value: dropdownvalue4,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Color.fromARGB(255, 181, 156, 255)),
                            items: items4.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue4) {
                              setState(() {
                                dropdownvalue4 = newValue4!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(),

                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(380, 50),
                            backgroundColor: Color.fromARGB(255, 181, 156, 255),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          validate();
                        },
                        child: Text(
                          'SAVE INFORMATION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (saved) ...[
                    Text(
                      'Saved successfully!',
                      style:
                          TextStyle(color: Color.fromARGB(255, 234, 236, 236)),
                    )
                  ],
                ],
              ),
            ),
          ),
        )));
  }
}
