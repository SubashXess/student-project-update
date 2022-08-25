import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmayg/image_preview_screen.dart';
import 'package:pmayg/user_type.dart';
import 'package:pmayg/verify_page.dart';

import 'Constants/ApiConstant.dart';
import 'Constants/ColorConstants.dart';
import 'MySharedPreferences.dart';
import 'dao/DatabaseHelper22.dart';
import 'dao/dio_upload_service.dart';
import 'dao/http_upload_service.dart';
import 'loader.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
//int status;
  DashboardPage() : super();
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  //final HttpUploadService _httpUploadService = HttpUploadService();
  //final DioUploadService _dioUploadService = DioUploadService();
  //String img1,img2,img3;
  String? reg_id, name, mobile, uid, user_type;
  //final dbHelper = DatabaseHelper22.instance;
  bool servicestatus = false;
  bool haspermission = false;
  bool visible = false;
  String? imagePath = '';
  var p1, p2, p3;
  // String base64String;
  // String selectedKhataNo,selectedPlotNo;
  bool isPressed = false;
  Color selectedPlotColor = const Color(0xff034B03);
  // String ref_ws;
  // int _selectedIndex;
  int status4 = 0;
  int maxStatus = 0;
  bool buttonenabled = false;
  //int reportCount;
  StreamController<int> streamController = new StreamController<int>();
  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance
        .getStringValue("usertype")
        .then((value) => setState(() {
              user_type = value;
            }));
    MySharedPreferences.instance
        .getStringValue("REG")
        .then((value) => setState(() {
              reg_id = value;
            }));
    MySharedPreferences.instance
        .getStringValue("UID")
        .then((value) => setState(() {
              uid = value;
              getPhase1(uid!);
              getPhase2(uid!);
              getPhase3(uid!);
            }));
    MySharedPreferences.instance
        .getStringValue("MOB")
        .then((value) => setState(() {
              mobile = value;
            }));
    MySharedPreferences.instance
        .getStringValue("NAME")
        .then((value) => setState(() {
              name = value;
            }));
  }

  // return SnackBar(
  //   content: Text(sms),
  //   backgroundColor: (Colors.black12),
  //   action: SnackBarAction(
  //     label: 'dismiss',
  //     onPressed: () {
  //     },
  //   ),
  // );
  //ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //}
  Future<void> logoutUser() async {
    MySharedPreferences.instance.removeAll();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserType()));
  }

  Widget setElevetedButton1(String? status, String? p_name) {
    Size size = MediaQuery.of(context).size;
    if ((p1?.length ?? 0) > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ImagePreviewScreen(appbartitle: '${p_name} View'),
                  ),
                );
                null;
                final snackBar = SnackBar(
                  content: Text('$p_name completed!'),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: '',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(
                Icons.check,
                size: 20,
                color: ColorConstants.kPrimaryColor,
              ), //icon data for elevated button
              label: Text(
                // p_name!,
                '$p_name View',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  // color: const Color(0xff17278d),
                  //color: Colors.deepPurple,
                  color: ColorConstants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 3.0,
                  color: ColorConstants.kPrimaryColor,
                ),
                elevation: 4,
                primary: ColorConstants.kPrimaryUltraLightColor,
                minimumSize: const Size(200, 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // textStyle:
                // const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          // Icon(
          //   Icons.check ,
          //   size: 25,
          //   color: ColorConstants.kPrimaryColor,
          // ),
          //  Positioned(
          //   right: 0,
          //   child: Text(
          //     'view',
          //     style: TextStyle(color: Colors.red, fontSize: 16.0),
          //   ),
          // ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyPage(status, p_name)),
                );
              },
              icon: Icon(
                Icons.lock_open,
                size: 20,
                color: ColorConstants.kPrimaryColor,
              ), //icon data for elevated button
              label: Text(
                p_name!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  // color: const Color(0xff17278d),
                  color: ColorConstants.kPrimaryColor,
                  //color: ColorConstants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 3.0,
                  color: ColorConstants.kPrimaryColor,
                ),
                elevation: 4,
                primary: ColorConstants.kPrimaryUltraLightColor,
                minimumSize: const Size(200, 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // textStyle:
                // const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          // Icon(
          //   Icons.check ,
          //   size: 25,
          //   color: ColorConstants.kPrimaryColor,
          // ),
        ],
      );
      // return Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children:<Widget>[
      //
      //     ElevatedButton(
      //
      //       child: Text(p_name!,style: TextStyle(
      //         fontStyle: FontStyle.italic,
      //         fontFamily: 'Roboto',
      //         fontSize: 18,
      //         // color: const Color(0xff17278d),
      //         //color: Colors.deepPurple,
      //         color: Colors.white,
      //         fontWeight: FontWeight.w500,
      //       ),
      //       ),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => VerifyPage(p_name)),
      //         );
      //       },
      //       style: ElevatedButton.styleFrom(
      //           primary: ColorConstants.kPrimaryColor,
      //           padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      //           textStyle:
      //           const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      //     ),
      //   ],
      // );
    }
  }

  Widget setElevetedButton2(String? status, String? p_name) {
    Size size = MediaQuery.of(context).size;
    if ((p2?.length ?? 0) > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ImagePreviewScreen(appbartitle: '${p_name} View'),
                  ),
                );
                null;
                final snackBar = SnackBar(
                  content: Text('${p_name} completed!'),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: '',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(
                Icons.check,
                size: 20,
                color: ColorConstants.kPrimaryColor,
              ), //icon data for elevated button
              label: Text(
                '$p_name View',
                // p_name!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  // color: const Color(0xff17278d),
                  //color: Colors.deepPurple,
                  color: ColorConstants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 3.0,
                  color: ColorConstants.kPrimaryColor,
                ),
                elevation: 4,
                primary: ColorConstants.kPrimaryUltraLightColor,
                minimumSize: const Size(200, 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // textStyle:
                // const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          // Icon(
          //   Icons.check ,
          //   size: 25,
          //   color: ColorConstants.kPrimaryColor,
          // ),
        ],
      );
    } else if ((p1?.length ?? 0) < 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                null;
                final snackBar = SnackBar(
                  content: Text(
                      'Before proceed Phase Two, complete Phase One First!'),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: '',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(
                Icons.lock,
                size: 20,
                color: ColorConstants.kPrimaryColor,
              ), //icon data for elevated button
              label: Text(
                p_name!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  // color: const Color(0xff17278d),
                  //color: Colors.deepPurple,
                  color: ColorConstants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 3.0,
                  color: ColorConstants.kPrimaryColor,
                ),
                elevation: 4,
                primary: ColorConstants.kPrimaryUltraLightColor,
                minimumSize: const Size(200, 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // textStyle:
                // const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          // Icon(
          //   Icons.check ,
          //   size: 25,
          //   color: ColorConstants.kPrimaryColor,
          // ),
        ],
      );
    } else if ((p1?.length ?? 0) > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyPage(status, p_name)),
                );
              },
              icon: Icon(
                Icons.lock_open,
                size: 20,
                color: ColorConstants.kPrimaryColor,
              ), //icon data for elevated button
              label: Text(
                p_name!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  // color: const Color(0xff17278d),
                  //color: Colors.deepPurple,
                  color: ColorConstants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 3.0,
                  color: ColorConstants.kPrimaryColor,
                ),
                elevation: 4,
                primary: ColorConstants.kPrimaryUltraLightColor,
                minimumSize: const Size(200, 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // textStyle:
                // const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          // Icon(
          //   Icons.check ,
          //   size: 25,
          //   color: ColorConstants.kPrimaryColor,
          // ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyPage(status, p_name)),
                );
              },
              icon: Icon(
                Icons.lock,
                size: 20,
                color: ColorConstants.kPrimaryColor,
              ), //icon data for elevated button
              label: Text(
                p_name!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  // color: const Color(0xff17278d),
                  color: ColorConstants.kPrimaryColor,
                  //color: ColorConstants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 3.0,
                  color: ColorConstants.kPrimaryColor,
                ),
                elevation: 4,
                primary: ColorConstants.kPrimaryUltraLightColor,
                minimumSize: const Size(200, 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // textStyle:
                // const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          // Icon(
          //   Icons.check ,
          //   size: 25,
          //   color: ColorConstants.kPrimaryColor,
          // ),
        ],
      );
    }
  }

  Widget setElevetedButton3(String? status, String? p_name) {
    Size size = MediaQuery.of(context).size;
    if ((p3?.length ?? 0) > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ImagePreviewScreen(appbartitle: '${p_name} View'),
                  ),
                );
                null;
                final snackBar = SnackBar(
                  content: Text(p_name! + ' completed!'),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: '',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(
                Icons.check,
                size: 20,
                color: ColorConstants.kPrimaryColor,
              ), //icon data for elevated button
              label: Text(
                // p_name!,
                '$p_name View',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  // color: const Color(0xff17278d),
                  //color: Colors.deepPurple,
                  color: ColorConstants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 3.0,
                  color: ColorConstants.kPrimaryColor,
                ),
                elevation: 4,
                primary: ColorConstants.kPrimaryUltraLightColor,
                minimumSize: const Size(200, 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // textStyle:
                // const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          // Icon(
          //   Icons.check ,
          //   size: 25,
          //   color: ColorConstants.kPrimaryColor,
          // ),
        ],
      );
    } else if ((p2?.length ?? 0) < 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                null;
                final snackBar = SnackBar(
                  content: Text(
                      'Before proceed Phase Three, complete Phase Two First!'),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: '',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(
                Icons.lock,
                size: 20,
                color: ColorConstants.kPrimaryColor,
              ), //icon data for elevated button
              label: Text(
                p_name!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  // color: const Color(0xff17278d),
                  //color: Colors.deepPurple,
                  color: ColorConstants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 3.0,
                  color: ColorConstants.kPrimaryColor,
                ),
                elevation: 4,
                primary: ColorConstants.kPrimaryUltraLightColor,
                minimumSize: const Size(200, 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // textStyle:
                // const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          // Icon(
          //   Icons.check ,
          //   size: 25,
          //   color: ColorConstants.kPrimaryColor,
          // ),
        ],
      );
    } else if ((p2?.length ?? 0) > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyPage(status, p_name)),
                );
              },
              icon: Icon(
                Icons.lock_open,
                size: 20,
                color: ColorConstants.kPrimaryColor,
              ), //icon data for elevated button
              label: Text(
                p_name!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  // color: const Color(0xff17278d),
                  //color: Colors.deepPurple,
                  color: ColorConstants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 3.0,
                  color: ColorConstants.kPrimaryColor,
                ),
                elevation: 4,
                primary: ColorConstants.kPrimaryUltraLightColor,
                minimumSize: const Size(200, 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // textStyle:
                // const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          // Icon(
          //   Icons.check ,
          //   size: 25,
          //   color: ColorConstants.kPrimaryColor,
          // ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: size.width * 0.6,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyPage(status, p_name)),
                );
              },
              icon: Icon(
                Icons.lock,
                size: 20,
                color: ColorConstants.kPrimaryColor,
              ), //icon data for elevated button
              label: Text(
                p_name!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  // color: const Color(0xff17278d),
                  color: ColorConstants.kPrimaryColor,
                  //color: ColorConstants.kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  width: 3.0,
                  color: ColorConstants.kPrimaryColor,
                ),
                elevation: 4,
                primary: ColorConstants.kPrimaryUltraLightColor,
                minimumSize: const Size(200, 60),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // textStyle:
                // const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          // Icon(
          //   Icons.check ,
          //   size: 25,
          //   color: ColorConstants.kPrimaryColor,
          // ),
        ],
      );
    }
  }

  showAlertDialog(BuildContext context, String desc) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
        backgroundColor: ColorConstants.kPrimaryUltraLightColor,
        title: Text(desc, style: TextStyle(fontSize: 18)),
        //content: Text("Before come to Phase Two Please complete Phase One."),
        actions: [
          okButton,
        ]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future getPhase1(String userid) async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });
    print('UID :$userid');
    var url = ApiConstant.api1 + 'getPhase1.php?uid=' + userid;
    var response = await http.get(Uri.parse(url)
        //     , body: {
        //   "uid": userid,
        // }
        );
    // Getting Server response into variable.
    print('DATA P1:' + response.body.length.toString());
    setState(() {
      p1 = jsonDecode(response.body);
      //image_db=message[0]['image'];
    });
    //print('IMG PF :'+image_db);
  }

  Future getPhase2(String userid) async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });
    var url = ApiConstant.api1 + 'getPhase2.php?uid=' + userid;
    var response = await http.post(Uri.parse(url)
        //     , body: {
        //   "uid": userid,
        // }
        );
    // Getting Server response into variable.
    print('DATA P2:' + response.body.length.toString());
    setState(() {
      p2 = jsonDecode(response.body);
      //image_db=message[0]['image'];
    });
    //print('IMG PF :'+image_db);
  }

  Future getPhase3(String userid) async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });
    var url = ApiConstant.api1 + 'getPhase3.php?uid=' + userid;
    var response = await http.post(Uri.parse(url)
        //     , body: {
        //   "uid": userid,
        // }
        );
    // Getting Server response into variable.
    print('DATA P3:' + response.body.length.toString());
    setState(() {
      p3 = jsonDecode(response.body);
      //image_db=message[0]['image'];
    });
    //print('IMG PF :'+image_db);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (user_type == 'b') {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                // Text('Beneficiary ',
                //   style: const TextStyle(
                //       fontFamily: 'Roboto',
                //       fontSize: 20,
                //       color: ColorConstants.kPrimaryColor,
                //       fontWeight: FontWeight.w700,
                //       fontStyle: FontStyle.italic
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                Text(
                  name.toString(),
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: ColorConstants.kPrimaryUltraLightColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                Text(
                  '( Mob : $mobile )',
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: ColorConstants.kPrimaryUltraLightColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          backgroundColor: ColorConstants.kPrimaryColor,
          centerTitle: true,
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                PopupMenuItem(child: Text("Logout"), value: 0),
                // PopupMenuItem(
                //     child: Text("New Group Chat"), value: "/new-group-chat"),
                //PopupMenuItem(child: Text("Settings"), value: "/settings"),
              ],
              onSelected: (route) {
                if (route == 0) {
                  logoutUser();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserType()),
                  );
                }
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login.jpg'),
              fit: BoxFit.contain,
            ),
          ),
          child: ListView(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: new AssetImage("assets/images/image-8.jpeg"),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    setElevetedButton1('1', 'Phase One'),
                    SizedBox(
                      height: 20,
                    ),
                    setElevetedButton2('2', 'Phase Two'),
                    SizedBox(
                      height: 20,
                    ),
                    setElevetedButton3('3', 'Phase Three')
                  ],
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              // margin: const EdgeInsets.only(top: 100),
              // child:Column(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children:<Widget>[
              //       GestureDetector(
              //         onTap: () async {
              //           // setState(() {
              //           //   showLoading = true;
              //           // });
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => VerifyPage('Phase One')),
              //           );
              //         },
              //         child:Container(
              //           height: 70,
              //           width: 165,
              //           margin: const EdgeInsets.only(left: 10,right: 10),
              //           decoration: BoxDecoration(
              //             border: Border.all(
              //               color: Colors.black,
              //             ),
              //             borderRadius: BorderRadius.only(
              //                 topRight: Radius.circular(10.0),
              //                 bottomRight: Radius.circular(10.0),
              //                 topLeft: Radius.circular(10),
              //                 bottomLeft: Radius.circular(10)
              //             ),
              //             color: Colors.white,
              //           ),
              //           child: const Center(
              //             child:Text("Phase One",style: TextStyle(
              //               fontStyle: FontStyle.italic,
              //               fontFamily: 'Roboto',
              //               fontSize: 18,
              //               // color: const Color(0xff17278d),
              //               //color: Colors.deepPurple,
              //               color: Colors.black,
              //               fontWeight: FontWeight.w500,
              //             ),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //         ),),
              //        SizedBox(
              //         height: 20,
              //       ),
              //       GestureDetector(
              //         onTap: () async {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => VerifyPage('Phase Two')),
              //           );
              //         },
              //         child:Container(
              //           height: 70,
              //           width: 165,
              //           margin: const EdgeInsets.only(left:10,right: 10),
              //           decoration: BoxDecoration(
              //             border: Border.all(
              //               color: Colors.black,
              //             ),
              //             color:  Colors.white,
              //             borderRadius: const BorderRadius.only(
              //                 topRight: const Radius.circular(10.0),
              //                 bottomRight: Radius.circular(10.0),
              //                 topLeft: const Radius.circular(10),
              //                 bottomLeft: const Radius.circular(10)
              //             ),
              //           ),
              //           child: const Center(
              //             // Column(
              //             //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             //   crossAxisAlignment: CrossAxisAlignment.start,
              //             //   children: [])
              //             child:const Text("Phase Two",style: TextStyle(
              //               fontStyle: FontStyle.italic,
              //               fontFamily: 'Roboto',
              //               fontSize: 18,
              //               // color: const Color(0xff17278d),
              //               //color: Colors.deepPurple,
              //               color: Colors.black,
              //               fontWeight: FontWeight.w500,
              //             ),
              //               textAlign: TextAlign.center,
              //             ),),
              //         ),),
              //       SizedBox(
              //         height: 20,
              //       ),
              //       GestureDetector(
              //         onTap: () async {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) =>VerifyPage('Phase Three')),
              //           );
              //         },
              //         child:Container(
              //           height: 70,
              //           width: 165,
              //           margin: const EdgeInsets.only(left:10,right: 10),
              //           decoration: BoxDecoration(
              //             border: Border.all(
              //               color: Colors.black,
              //             ),
              //             color:  Colors.white,
              //             borderRadius: const BorderRadius.only(
              //                 topRight: const Radius.circular(10.0),
              //                 bottomRight: Radius.circular(10.0),
              //                 topLeft: const Radius.circular(10),
              //                 bottomLeft: const Radius.circular(10)
              //             ),
              //           ),
              //           child: const Center(
              //             // Column(
              //             //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             //   crossAxisAlignment: CrossAxisAlignment.start,
              //             //   children: [])
              //             child:const Text("Phase Three",style: TextStyle(
              //               fontStyle: FontStyle.italic,
              //               fontFamily: 'Roboto',
              //               fontSize: 18,
              //               // color: const Color(0xff17278d),
              //               //color: Colors.deepPurple,
              //               color: Colors.black,
              //               fontWeight: FontWeight.w500,
              //             ),
              //               textAlign: TextAlign.center,
              //             ),),
              //         ),),
              //     ]
              // ),
              // ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                // Text('Beneficiary ',
                //   style: const TextStyle(
                //       fontFamily: 'Roboto',
                //       fontSize: 20,
                //       color: ColorConstants.kPrimaryColor,
                //       fontWeight: FontWeight.w700,
                //       fontStyle: FontStyle.italic
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                Text(
                  name.toString(),
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      color: ColorConstants.kPrimaryUltraLightColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                Text(
                  '( Mob : $mobile )',
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: ColorConstants.kPrimaryUltraLightColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          backgroundColor: ColorConstants.kPrimaryColor,
          centerTitle: true,
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                PopupMenuItem(child: Text("Logout"), value: 0),
                // PopupMenuItem(
                //     child: Text("New Group Chat"), value: "/new-group-chat"),
                //PopupMenuItem(child: Text("Settings"), value: "/settings"),
              ],
              onSelected: (route) {
                if (route == 0) {
                  logoutUser();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserType()),
                  );
                }
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login.jpg'),
              fit: BoxFit.contain,
            ),
          ),
          child: ListView(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: new AssetImage("assets/images/image-8.jpeg"),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('data'),
                    setElevetedButton1('1', 'Phase One'),
                    SizedBox(
                      height: 20,
                    ),
                    setElevetedButton2('2', 'Phase Two'),
                    SizedBox(
                      height: 20,
                    ),
                    setElevetedButton3('3', 'Phase Three')
                  ],
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              // margin: const EdgeInsets.only(top: 100),
              // child:Column(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children:<Widget>[
              //       GestureDetector(
              //         onTap: () async {
              //           // setState(() {
              //           //   showLoading = true;
              //           // });
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => VerifyPage('Phase One')),
              //           );
              //         },
              //         child:Container(
              //           height: 70,
              //           width: 165,
              //           margin: const EdgeInsets.only(left: 10,right: 10),
              //           decoration: BoxDecoration(
              //             border: Border.all(
              //               color: Colors.black,
              //             ),
              //             borderRadius: BorderRadius.only(
              //                 topRight: Radius.circular(10.0),
              //                 bottomRight: Radius.circular(10.0),
              //                 topLeft: Radius.circular(10),
              //                 bottomLeft: Radius.circular(10)
              //             ),
              //             color: Colors.white,
              //           ),
              //           child: const Center(
              //             child:Text("Phase One",style: TextStyle(
              //               fontStyle: FontStyle.italic,
              //               fontFamily: 'Roboto',
              //               fontSize: 18,
              //               // color: const Color(0xff17278d),
              //               //color: Colors.deepPurple,
              //               color: Colors.black,
              //               fontWeight: FontWeight.w500,
              //             ),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //         ),),
              //        SizedBox(
              //         height: 20,
              //       ),
              //       GestureDetector(
              //         onTap: () async {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => VerifyPage('Phase Two')),
              //           );
              //         },
              //         child:Container(
              //           height: 70,
              //           width: 165,
              //           margin: const EdgeInsets.only(left:10,right: 10),
              //           decoration: BoxDecoration(
              //             border: Border.all(
              //               color: Colors.black,
              //             ),
              //             color:  Colors.white,
              //             borderRadius: const BorderRadius.only(
              //                 topRight: const Radius.circular(10.0),
              //                 bottomRight: Radius.circular(10.0),
              //                 topLeft: const Radius.circular(10),
              //                 bottomLeft: const Radius.circular(10)
              //             ),
              //           ),
              //           child: const Center(
              //             // Column(
              //             //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             //   crossAxisAlignment: CrossAxisAlignment.start,
              //             //   children: [])
              //             child:const Text("Phase Two",style: TextStyle(
              //               fontStyle: FontStyle.italic,
              //               fontFamily: 'Roboto',
              //               fontSize: 18,
              //               // color: const Color(0xff17278d),
              //               //color: Colors.deepPurple,
              //               color: Colors.black,
              //               fontWeight: FontWeight.w500,
              //             ),
              //               textAlign: TextAlign.center,
              //             ),),
              //         ),),
              //       SizedBox(
              //         height: 20,
              //       ),
              //       GestureDetector(
              //         onTap: () async {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) =>VerifyPage('Phase Three')),
              //           );
              //         },
              //         child:Container(
              //           height: 70,
              //           width: 165,
              //           margin: const EdgeInsets.only(left:10,right: 10),
              //           decoration: BoxDecoration(
              //             border: Border.all(
              //               color: Colors.black,
              //             ),
              //             color:  Colors.white,
              //             borderRadius: const BorderRadius.only(
              //                 topRight: const Radius.circular(10.0),
              //                 bottomRight: Radius.circular(10.0),
              //                 topLeft: const Radius.circular(10),
              //                 bottomLeft: const Radius.circular(10)
              //             ),
              //           ),
              //           child: const Center(
              //             // Column(
              //             //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //             //   crossAxisAlignment: CrossAxisAlignment.start,
              //             //   children: [])
              //             child:const Text("Phase Three",style: TextStyle(
              //               fontStyle: FontStyle.italic,
              //               fontFamily: 'Roboto',
              //               fontSize: 18,
              //               // color: const Color(0xff17278d),
              //               //color: Colors.deepPurple,
              //               color: Colors.black,
              //               fontWeight: FontWeight.w500,
              //             ),
              //               textAlign: TextAlign.center,
              //             ),),
              //         ),),
              //     ]
              // ),
              // ),
            ],
          ),
        ),
      );
    }
  }
}






// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pmayg/Widgets/background.dart';
// import 'package:pmayg/user_type.dart';
// import 'package:pmayg/verify_page.dart';
//
// import 'Constants/ColorConstants.dart';
// import 'MySharedPreferences.dart';
// import 'dao/DatabaseHelper22.dart';
// import 'dao/dio_upload_service.dart';
// import 'dao/http_upload_service.dart';
// import 'loader.dart';
//
// class DashboardPage extends StatefulWidget {
// //int status;
//   DashboardPage() : super();
//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }
//
// class _DashboardPageState extends State<DashboardPage>
//     with SingleTickerProviderStateMixin {
//   //final HttpUploadService _httpUploadService = HttpUploadService();
//   //final DioUploadService _dioUploadService = DioUploadService();
//   //String img1,img2,img3;
//   String? reg_id, name, mobile;
//   //final dbHelper = DatabaseHelper22.instance;
//   bool servicestatus = false;
//   bool haspermission = false;
//   // LocationPermission permission;
//   // String _scanBarcode = 'Unknown';
//   // Position position;
//   // String long = "", lat = "";
//   // StreamSubscription<Position> positionStream;
//   // CameraDescription _cameraDescription;
//   List<String> _images = [];
//   String imagePath = '';
//   // String base64String;
//   // String selectedKhataNo,selectedPlotNo;
//   bool isPressed = false;
//   Color selectedPlotColor = const Color(0xff034B03);
//   // String ref_ws;
//   // int _selectedIndex;
//   int status4 = 0;
//   int maxStatus = 0;
//   //int reportCount;
//   StreamController<int> streamController = new StreamController<int>();
//   @override
//   void initState() {
//     super.initState();
//     MySharedPreferences.instance
//         .getStringValue("REG")
//         .then((value) => setState(() {
//               reg_id = value;
//             }));
//     MySharedPreferences.instance
//         .getStringValue("MOB")
//         .then((value) => setState(() {
//               mobile = value;
//             }));
//     MySharedPreferences.instance
//         .getStringValue("NAME")
//         .then((value) => setState(() {
//               name = value;
//             }));
//   }
//
//   Future<void> logoutUser() async {
//     MySharedPreferences.instance.removeAll();
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => UserType()));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         toolbarHeight: kToolbarHeight * 1.4,
//         title: Container(
//           margin: const EdgeInsets.only(top: 10, bottom: 10),
//           child: Column(
//             children: [
//               Text(
//                 'Beneficiary ',
//                 style: const TextStyle(
//                     fontFamily: 'Roboto',
//                     fontSize: 20,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontStyle: FontStyle.italic),
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 name.toString(),
//                 style: const TextStyle(
//                     fontFamily: 'Roboto',
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontStyle: FontStyle.italic),
//                 textAlign: TextAlign.center,
//               ),
//               // const SizedBox(
//               //   height: 5,
//               // ),
//               Text(
//                 '( Mob : ' + mobile.toString() + ' )',
//                 style: const TextStyle(
//                     fontFamily: 'Roboto',
//                     fontSize: 16,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontStyle: FontStyle.italic),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//         backgroundColor: ColorConstants.kPrimaryColor,
//         centerTitle: true,
//         actions: [
//           PopupMenuButton(
//             itemBuilder: (BuildContext bc) => [
//               PopupMenuItem(child: Text("Logout"), value: 0),
//               // PopupMenuItem(
//               //     child: Text("New Group Chat"), value: "/new-group-chat"),
//               //PopupMenuItem(child: Text("Settings"), value: "/settings"),
//             ],
//             onSelected: (route) {
//               if (route == 0) {
//                 logoutUser();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => UserType()),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         child: Background(
//           child: Container(
//             // decoration: const BoxDecoration(
//             //   image: DecorationImage(
//             //     image: AssetImage('assets/images/login.jpg'),
//             //     fit: BoxFit.contain,
//             //   ),
//             // ),
//             child: ListView(
//               children: [
//                 // Center(
//                 //   child:Container(
//                 //     margin: const EdgeInsets.only(top: 20),
//                 //     width: 200,
//                 //     height: 200,
//                 //     decoration: BoxDecoration(
//                 //       shape: BoxShape.circle,
//                 //       image: DecorationImage(
//                 //           image: new AssetImage("assets/images/pmaj.png"),
//                 //           fit: BoxFit.fill
//                 //       ),
//                 //     ),
//                 //   ),),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 // Container(
//                 //   //height: 150,
//                 //   width: double.infinity,
//                 //   decoration: const BoxDecoration(
//                 //     borderRadius: BorderRadius.only(
//                 //       bottomLeft: Radius.circular(30.0),
//                 //       bottomRight: Radius.circular(30.0),
//                 //     ),
//                 //     color: ColorConstants.kPrimaryUltraLightColor,
//                 //   ),
//                 // ),
//                 // Container(
//                 //   //padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
//                 //   decoration: const BoxDecoration(
//                 //     borderRadius: BorderRadius.only(
//                 //       bottomLeft: Radius.circular(20.0),
//                 //       bottomRight: Radius.circular(20.0),
//                 //     ),
//                 //     color:ColorConstants.kPrimaryUltraLightColor,
//                 //   ),
//                 //   child: Column(
//                 //     crossAxisAlignment: CrossAxisAlignment.start,
//                 //     children: <Widget>[
//                 //     ],
//                 //   ),
//                 // ),
//                 Container(
//                   alignment: Alignment.center,
//                   margin: const EdgeInsets.only(top: 100),
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         GestureDetector(
//                           onTap: () async {
//                             // setState(() {
//                             //   showLoading = true;
//                             // });
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       VerifyPage('Phase One')),
//                             );
//                           },
//                           child: Container(
//                             height: 70,
//                             width: 165,
//                             margin: const EdgeInsets.only(left: 10, right: 10),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.black,
//                               ),
//                               borderRadius: BorderRadius.only(
//                                   topRight: Radius.circular(10.0),
//                                   bottomRight: Radius.circular(10.0),
//                                   topLeft: Radius.circular(10),
//                                   bottomLeft: Radius.circular(10)),
//                               color: Colors.white,
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Phase One",
//                                 style: TextStyle(
//                                   fontStyle: FontStyle.italic,
//                                   fontFamily: 'Roboto',
//                                   fontSize: 18,
//                                   // color: const Color(0xff17278d),
//                                   //color: Colors.deepPurple,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         GestureDetector(
//                           onTap: () async {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       VerifyPage('Phase Two')),
//                             );
//                           },
//                           child: Container(
//                             height: 70,
//                             width: 165,
//                             margin: const EdgeInsets.only(left: 10, right: 10),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.black,
//                               ),
//                               color: Colors.white,
//                               borderRadius: const BorderRadius.only(
//                                   topRight: const Radius.circular(10.0),
//                                   bottomRight: Radius.circular(10.0),
//                                   topLeft: const Radius.circular(10),
//                                   bottomLeft: const Radius.circular(10)),
//                             ),
//                             child: const Center(
//                               // Column(
//                               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               //   crossAxisAlignment: CrossAxisAlignment.start,
//                               //   children: [])
//                               child: const Text(
//                                 "Phase Two",
//                                 style: TextStyle(
//                                   fontStyle: FontStyle.italic,
//                                   fontFamily: 'Roboto',
//                                   fontSize: 18,
//                                   // color: const Color(0xff17278d),
//                                   //color: Colors.deepPurple,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         GestureDetector(
//                           onTap: () async {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       VerifyPage('Phase Three')),
//                             );
//                           },
//                           child: Container(
//                             height: 70,
//                             width: 165,
//                             margin: const EdgeInsets.only(left: 10, right: 10),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.black,
//                               ),
//                               color: Colors.white,
//                               borderRadius: const BorderRadius.only(
//                                   topRight: const Radius.circular(10.0),
//                                   bottomRight: Radius.circular(10.0),
//                                   topLeft: const Radius.circular(10),
//                                   bottomLeft: const Radius.circular(10)),
//                             ),
//                             child: const Center(
//                               // Column(
//                               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               //   crossAxisAlignment: CrossAxisAlignment.start,
//                               //   children: [])
//                               child: const Text(
//                                 "Phase Three",
//                                 style: TextStyle(
//                                   fontStyle: FontStyle.italic,
//                                   fontFamily: 'Roboto',
//                                   fontSize: 18,
//                                   // color: const Color(0xff17278d),
//                                   //color: Colors.deepPurple,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ]),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
