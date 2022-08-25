// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pmayg/Constants/ColorConstants.dart';
import 'package:pmayg/Widgets/background.dart';
import 'package:pmayg/dao/MySharedPreferences.dart';
import 'package:pmayg/image_preview_screen.dart';
import 'package:pmayg/user_type.dart';

class ReviewerDashboard extends StatefulWidget {
  const ReviewerDashboard({Key? key}) : super(key: key);

  @override
  State<ReviewerDashboard> createState() => _ReviewerDashboardState();
}

class _ReviewerDashboardState extends State<ReviewerDashboard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.kPrimaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Review'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext bc) => [
              const PopupMenuItem(value: 0, child: Text("Logout")),
              // PopupMenuItem(
              //     child: Text("New Group Chat"), value: "/new-group-chat"),
              //PopupMenuItem(child: Text("Settings"), value: "/settings"),
            ],
            onSelected: (route) {
              if (route == 0) {
                logoutUser();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => UserType()),
                // );
              }
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.8,
                  child: Image.asset(
                    'assets/images/image-8.jpeg',
                    height: size.height * 0.26,
                    fit: BoxFit.cover,
                    // color: Colors.black38,
                  ),
                ),
                SizedBox(height: size.height * 0.036),
                const Text(
                  'Beneficiary ID : 85421036',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.036),
                buttonWidget(
                  size: size,
                  label: 'View Phase One',
                  icon: Icons.lock,
                  onPressed: () {
                    print('one');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImagePreviewScreen(
                          appbartitle: 'View Phase One',
                          ratingShow: true,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.016),
                buttonWidget(
                  size: size,
                  label: 'View Phase Two',
                  icon: Icons.lock,
                  onPressed: () {
                    print('two');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImagePreviewScreen(
                          appbartitle: 'View Phase Two',
                          ratingShow: true,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.016),
                buttonWidget(
                  size: size,
                  label: 'View Phase Three',
                  icon: Icons.lock,
                  onPressed: () {
                    print('three');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImagePreviewScreen(
                          appbartitle: 'View Phase Three',
                          ratingShow: true,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonWidget(
      {Size? size, String? label, IconData? icon, VoidCallback? onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(ColorConstants.kPrimaryColor),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
        maximumSize: MaterialStateProperty.all(
            Size(size!.width * 0.6, size.height * 0.065)),
        minimumSize: MaterialStateProperty.all(
            Size(size.width * 0.6, size.height * 0.065)),
      ),
      icon: Icon(
        icon,
        size: 20.0,
      ),
      label: Text(
        label.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> logoutUser() async {
    MySharedPreferences.instance.removeAll();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserType()));
  }
}
