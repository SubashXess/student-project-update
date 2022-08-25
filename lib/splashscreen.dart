// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pmayg/Constants/ColorConstants.dart';
import 'package:pmayg/reviewer_dashboard.dart';
import 'package:pmayg/reviewer_search_page.dart';
import 'package:pmayg/user_type.dart';
import 'package:pmayg/verify_page.dart';
import '../MySharedPreferences.dart';
import 'dashboard.dart';
import 'loginpage.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static String mob = "";
  bool isLoggedIn = false;
  SplashScreenState() {
    MySharedPreferences.instance
        .getBooleanValue("loggedin")
        .then((value) => setState(() {
              isLoggedIn = value;
              //print('Splashscreen Pref :'+mob1.toString());
            }));
  }
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      check();
    });
  }

  Future check() async {
    print('STATUS CHK :$isLoggedIn');
    if (isLoggedIn == false) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => UserType()));
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => ReviewerDashboard()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image-8.jpeg'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
