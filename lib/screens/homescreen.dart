import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slides_share_user/controllers/authController.dart';
import 'package:slides_share_user/screens/loginScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHovered = false;
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  String? selectedCourseName; // Track the selected course name
  DocumentReference? selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff72503c),
        title: const Text('SlideTech'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await AuthController().logOut();
               Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 70),
                primary: Colors.redAccent, // Set the button background color
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          return Row(
            children: [
              Container(
                width: width * 0.3,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, left: 12, bottom: 12, right: 4),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black26),
                        color: Color.fromARGB(255, 255, 255, 255)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Courses',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2,
                                    color: Color(
                                        0xff72503c)), // Change focus border color to blue

                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(Icons.search,
                                  color: Colors.grey), // Add a search icon
                            ),
                            controller: searchController,
                            onChanged: (query) {
                              setState(() {
                                searchText = query;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Courses',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 22),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('courses')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  var courses = snapshot.data!.docs;

                                  // Filter courses based on search text
                                  if (searchText.isNotEmpty) {
                                    courses = courses.where((doc) {
                                      final courseName = doc['name'] as String;
                                      return courseName
                                          .toLowerCase()
                                          .contains(searchText.toLowerCase());
                                    }).toList();
                                  }

                                  return GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 230,
                                              childAspectRatio: 3,
                                              mainAxisExtent: 150),
                                      itemCount: courses.length,
                                      itemBuilder: (context, index) {
                                        var course = courses[index];
                                        var courseName = course['name'];
                                        final isSelected =
                                            selectedCourse == course.reference;

                                        return Card(
                                          color: isSelected
                                              ? Colors.grey[300]
                                              : null, // Set a different background color for the selected course
                                          child: InkWell(
                                            onTap: () async {
                                              final courseName =
                                                  await getCourseName(
                                                      course.reference);
                                              setState(() {
                                                selectedCourseName = courseName;
                                                selectedCourse =
                                                    course.reference;
                                              });
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  CupertinoIcons.folder_fill,
                                                  color: Colors.lightBlue[300],
                                                  size: 80,
                                                ),
                                                Text(
                                                  courseName,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: width * 0.7,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, right: 12, bottom: 12, left: 4),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black26),
                        color: Color.fromARGB(255, 255, 255, 255)),
                    child: Column(
                      children: [
                        if (selectedCourseName != null)
                          Text(
                            '$selectedCourseName',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                        Expanded(
                          child: selectedCourse == null
                              // ignore: avoid_unnecessary_containers
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      height:
                                          500, // Adjust the height as needed
                                      autoPlay: true, // Enable auto play
                                      autoPlayInterval:
                                          Duration(seconds: 3), // Set interval
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                    ),
                                    items: [
                                      Image.asset(
                                          'assets/08.jpg'), // Add your images here
                                      Image.asset(
                                          'assets/09.jpg'), // Add more images as needed
                                      // Add more images as needed
                                    ],
                                  ),
                                )
                              // Container(
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(10),
                              //         image: DecorationImage(
                              //           image: AssetImage('assets/08.jpg'),
                              //           fit: BoxFit.cover,
                              //         )
                              //         ),
                              //     child: const Center(
                              //       child: Text(
                              //         "Select a course on your left to view its slides",
                              //         style: TextStyle(
                              //             fontSize: 28, color: Colors.white),
                              //       ),
                              //     ),
                              //   )
                              : StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('files')
                                      .where('course',
                                          isEqualTo: selectedCourseName)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    var files = snapshot.data!.docs;

                                    if (files.isEmpty) {
                                      // If no files found, show a file icon and a message
                                      return const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.file_copy,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              'This folder is empty, no slides uploaded yet',
                                              style: TextStyle(fontSize: 18),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      itemCount: files.length,
                                      itemBuilder: (context, index) {
                                        var file = files[index];
                                        var fileName = file['name'];
                                        var fileUrl = file['file Url'];

                                        return ListTile(
                                          title: Text(fileName),
                                          leading:
                                              const Icon(Icons.file_present),
                                          trailing: ElevatedButton(
                                            onPressed: () {
                                              _launchURL(
                                                  fileUrl); // Function to open the file URL
                                            },
                                            child: const Text('Download'),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<String> getCourseName(DocumentReference courseRef) async {
    final doc = await courseRef.get();
    if (doc.exists) {
      return doc['name'] as String;
    } else {
      return 'Course Not Found'; // or any default value
    }
  }

  // Function to open the file URL for downloading
  _launchURL(String url) async {
    var uri = Uri.parse(url); // Create a Uri from the URL string
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
