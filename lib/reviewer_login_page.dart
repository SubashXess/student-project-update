// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pmayg/Constants/ApiConstant.dart';
import 'package:pmayg/Widgets/background.dart';
import 'package:pmayg/Widgets/rounded_button_widget.dart';
import 'package:pmayg/Widgets/show_snack_bar.dart';
import 'package:pmayg/Widgets/textformfield_widget.dart';
import 'package:pmayg/constants/ColorConstants.dart';
import 'package:pmayg/dao/MySharedPreferences.dart';
import 'package:pmayg/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pmayg/reviewer_dashboard.dart';
import 'package:pmayg/reviewer_search_page.dart';

class ReviewerLoginPage extends StatefulWidget {
  const ReviewerLoginPage({Key? key}) : super(key: key);

  @override
  State<ReviewerLoginPage> createState() => _ReviewerLoginPageState();
}

class _ReviewerLoginPageState extends State<ReviewerLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _regController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isHidePassword = true;
  bool visible = false;
  @override
  void initState() {
    _phoneController.addListener(onListen);
    _regController.addListener(onListen);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _regController.removeListener(onListen);
    _regController.dispose();
    _phoneController.removeListener(onListen);
    _phoneController.dispose();
  }

  void onListen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   icon: Icon(
          //     Icons.arrow_back,
          //     color: Colors.white,
          //   ),
          // ),
          title: const Text(
            'Reviewer Login',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          backgroundColor: ColorConstants.kPrimaryColor,
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage(
          //         'assets/images/login.jpg'),
          //     fit: BoxFit.contain,
          //   ),
          // ),
          child: Background(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 16.0),
                  child: Form(
                    key: _formKey,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // InkWell(
                        //   onTap: () => Navigator.pop(context),
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   child: Container(
                        //     padding: const EdgeInsets.all(8.0),
                        //     clipBehavior: Clip.antiAliasWithSaveLayer,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       border: Border.all(
                        //         color: ColorConstants.kPrimaryLightColor1,
                        //         width: 1.0,
                        //       ),
                        //     ),
                        //     child: const Icon(
                        //       Icons.arrow_back_ios_rounded,
                        //       size: 20.0,
                        //       color: ColorConstants.kSecondaryColor,
                        //     ),
                        //   ),
                        // ),
                        //SizedBox(height: size.height * 0.06),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/image-8.jpeg"),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            // Center(
                            // child:Container(
                            //   width: 200,
                            //   height: 200,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     image: DecorationImage(
                            //         image: new AssetImage("assets/images/pmaj.png"),
                            //         fit: BoxFit.fill
                            //     ),
                            //   ),
                            // ),),
                            SizedBox(height: size.height * 0.016),
                            const Center(
                              child: Text(
                                "PMAY-G",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: ColorConstants.kSecondaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // SizedBox(height: size.height * 0.016),
                            // const Text(
                            //   "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //     fontSize: 16.0,
                            //     color: ColorConstants.kSecondaryLightColor,
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.040),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormFieldWidget(
                              controller: _regController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              label: "Registration ID",
                              labelColor:
                                  ColorConstants.kPrimaryColor.withAlpha(160),
                              borderColor:
                                  ColorConstants.kPrimaryUltraLightColor,
                              bgColor: ColorConstants.kPrimaryUltraLightColor,
                              //validator: TextFieldValidation.userMobileValidation,
                              inputType: TextInputType.text,
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                            SizedBox(height: size.height * 0.012),
                            const Text(
                              'OR',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: size.height * 0.012),
                            TextFormFieldWidget(
                              controller: _phoneController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              label: "Mobile No",
                              labelColor:
                                  ColorConstants.kPrimaryColor.withAlpha(160),
                              borderColor:
                                  ColorConstants.kPrimaryUltraLightColor,
                              bgColor: ColorConstants.kPrimaryUltraLightColor,
                              //validator: TextFieldValidation.userMobileValidation,
                              inputType: TextInputType.number,
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                            SizedBox(height: size.height * 0.016),
                            RoundedButtonWidget(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => VerifyPage()),
                                // );
                                // if (_formKey.currentState!.validate()) {
                                //   // Navigator.of(context)
                                //   //     .pushNamed('dashboard_page');
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  ColorConstants.kPrimaryColor),
                                        ),
                                      );
                                    });
                                userLogin();
                                // } else {
                                //   print("Error");
                                // }
                              },
                              label: "Login",
                              bgColor: ColorConstants.kPrimaryColor,
                              labelColor: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future userLogin() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });
    String p_reg = _regController.text;
    String p_mob = _phoneController.text;
    // print('Email : $email Password : $password');
    // SERVER LOGIN API URL
    var url = '${ApiConstant.api1}login.php';
    var response = await http.post(Uri.parse(url), body: {
      "reg_id": p_reg,
      "mobile": p_mob,
    });
    // Getting Server response into variable.
    print(response.body.toString());
    var message = jsonDecode(response.body);
    String id = message[0]['user_id'];
    String reg = message[0]['reg_id'];
    String name = message[0]['name'];
    String mobile = message[0]['mobile'];
    String user_type = message[0]['user_type'];
    //String password=message[0]['password'];
    print('MOB : $mobile');
    //String password=message['password'];
    if (p_reg == reg || p_mob == mobile) {
      if (user_type == 'v') {
        MySharedPreferences.instance.setStringValue("UID", id);
        MySharedPreferences.instance.setStringValue("REG", reg);
        MySharedPreferences.instance.setStringValue("MOB", mobile);
        MySharedPreferences.instance.setStringValue("NAME", name);
        MySharedPreferences.instance.setBooleanValue("loggedin", true);
        MySharedPreferences.instance.setStringValue("usertype", user_type);
        //Navigator.of(context).pushNamed('/dashboard_page');
        // Hiding the CircularProgressIndicator.

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const ReviewerSearchPage()));
        setState(() {
          visible = false;
        });
      }
      // else {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'You are not authorized to view this page');
      // }
    } else {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.

      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message["message"]),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
