import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:slides_share_user/controllers/authController.dart';
import 'package:slides_share_user/screens/initialHomeScreen.dart';
import 'package:slides_share_user/screens/loginScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRowOpen = true; // Initialize it with an initial value
  bool isHovered = false;
  TextEditingController searchController = TextEditingController();
  String searchText = '';
  String? selectedCourseName; // Track the selected course name
  DocumentReference? selectedCourse;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff72503c),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0), // Add a bottom stroke
          child: Container(
            height: 1,
            color: Colors.grey[350], // Color of the bottom stroke
          ),
        ),
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
                        builder: (context) => const InitialHomeScreen()));
              },
              icon: const Icon(
                Icons.logout,
                size: 20,
              ),
              label: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                // fixedSize: const Size(120, 70),
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
          icon: Icon(isRowOpen ? Icons.close_rounded : Icons.menu_rounded),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isRowOpen)
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: screenWidth * 0.3,
                  // height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                          child: CupertinoTextField(
                            placeholder: 'Search',
                            placeholderStyle:
                                TextStyle(fontSize: 12, color: Colors.grey),
                            // padding: const EdgeInsets.all(10),
                            controller: searchController,
                            style: TextStyle(fontSize: 12), // Input text style

                            onChanged: (query) {
                              setState(() {
                                searchText = query;
                              });
                            },
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(CupertinoIcons.search,
                                  size: 12, color: Colors.grey),
                            ),
                          ),
                        ),
                        const Gap(4),
                        const Text(
                          'Courses',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 22),
                          textAlign: TextAlign.left,
                        ),
                        const Gap(8),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
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
                                          childAspectRatio: 4,
                                          mainAxisExtent: 115),
                                  itemCount: courses.length,
                                  itemBuilder: (context, index) {
                                    var course = courses[index];
                                    var courseName = course['name'];
                                    final isSelected =
                                        selectedCourse == course.reference;

                                    return Card(
                                      color:
                                          isSelected ? Colors.grey[300] : null,
                                      child: InkWell(
                                        onTap: () async {
                                          final courseName =
                                              await getCourseName(
                                                  course.reference);
                                          setState(() {
                                            selectedCourseName = courseName;
                                            selectedCourse = course.reference;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                CupertinoIcons.folder_fill,
                                                color: Colors.lightBlue[300],
                                                size: 50,
                                              ),
                                              Text(
                                                courseName,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(18, 0, 0, 0), // Shadow color
                            offset: Offset(0, 2), // Offset of the shadow
                            blurRadius: 6, // Spread of the shadow
                            spreadRadius: 0, // Optional: Expand the shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black26, width: 1.5),
                        color: Colors.white),
                    // height: MediaQuery.of(context).size.height,
                    width: isRowOpen
                        ? (MediaQuery.of(context).size.width * 0.7)
                        : MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (selectedCourseName != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 12.0, bottom: 12),
                            child: Text(
                              '$selectedCourseName',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24),
                            ),
                          ),
                        Container(
                          // color: Colors.blueAccent,
                          height: MediaQuery.of(context).size.height,
                          child: selectedCourse == null
                              // ignore: avoid_unnecessary_containers
                              ? Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white),
                                  child: const Center(
                                    child: Text(
                                      'No Course Folder Selected',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ),
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
                                            Gap(12),
                                            Text(
                                              'This folder is empty, no slides uploaded yet',
                                              style: TextStyle(fontSize: 24),
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
                                        final isLastItem =
                                            index == files.length - 1;
                                        return Column(
                                          children: [
                                            ListTile(
                                              dense: true,
                                              horizontalTitleGap: 4,
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: 0,
                                                      vertical: -4),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              title: Text(
                                                fileName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              leading: const Icon(
                                                  Icons.file_present),
                                              trailing: InkWell(
                                                onTap: () {
                                                  _launchURL(fileUrl);
                                                },
                                                child: const Icon(
                                                  Icons.download_rounded,
                                                  color: Colors.blueAccent,
                                                  size: 20,
                                                ),
                                              ),
                                            ),

                                            if (!isLastItem)
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0, right: 16),
                                                child: Divider(),
                                              ), // Add a Divider after all items except the last one
                                          ],
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
            ),
          ],
        );
      }),
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
