import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  bool isRowOpen = false; // Initialize it with an initial value
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
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await AuthController().logOut();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 70),
                // ignore: deprecated_member_use
                primary: Colors.redAccent, // Set the button background color
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            setState(() {
              isRowOpen =
                  !isRowOpen; // Toggle the value to open/close the drawer
            });
          },
          icon: Icon(isRowOpen ? Icons.menu_open : Icons.menu),
        ),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isRowOpen)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                      ),
                      child: Expanded(
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          // height: MediaQuery.of(context).size.height,

                          child: Container(
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                // border: Border.all(color: Colors.black26),
                                color: Colors.blue),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search Courses',
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2, color: Color(0xff72503c)),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      labelStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                      prefixIcon: const Icon(Icons.search,
                                          color: Colors.grey),
                                    ),
                                    controller: searchController,
                                    onChanged: (query) {
                                      setState(() {
                                        searchText = query;
                                      });
                                    },
                                  ),
                                  const Gap(
                                    4,
                                  ),
                                  const Text(
                                    'Courses',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 22),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    color: Colors.amberAccent,
                                    height: MediaQuery.of(context).size.height,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('courses')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        var courses = snapshot.data!.docs;

                                        // Filter courses based on search text
                                        if (searchText.isNotEmpty) {
                                          courses = courses.where((doc) {
                                            final courseName =
                                                doc['name'] as String;
                                            return courseName
                                                .toLowerCase()
                                                .contains(
                                                    searchText.toLowerCase());
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
                                                  selectedCourse ==
                                                      course.reference;

                                              return Card(
                                                color: isSelected
                                                    ? Colors.grey[300]
                                                    : null,
                                                child: InkWell(
                                                  onTap: () async {
                                                    final courseName =
                                                        await getCourseName(
                                                            course.reference);
                                                    setState(() {
                                                      selectedCourseName =
                                                          courseName;
                                                      selectedCourse =
                                                          course.reference;
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons
                                                            .folder_fill,
                                                        color: Colors
                                                            .lightBlue[300],
                                                        size: 80,
                                                      ),
                                                      Text(
                                                        courseName,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black,
                      height: MediaQuery.of(context).size.height,
                      width: 1,
                    )
                  ],
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black26),
                        color: Colors.red),
                    child: Column(
                      children: [
                        if (selectedCourseName != null)
                          Text(
                            '$selectedCourseName',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                        Container(
                          color: Colors.blueAccent,
                          height: MediaQuery.of(context).size.height,
                          child: selectedCourse == null
                              // ignore: avoid_unnecessary_containers
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    // height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.amber),
                                  ),
                                )
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
        }),
      ),
    );
  }

  Future<String> getCourseName(DocumentReference courseRef) async {
    final doc = await courseRef.get();
    if (doc.exists) {
      return doc['name'] as String;
    } else {
      return 'Course Not Found';
    }
  }

  _launchURL(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
