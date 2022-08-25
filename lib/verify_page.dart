// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmayg/Widgets/background.dart';
import 'package:pmayg/user_type.dart';
import 'package:sqflite/sqflite.dart';
import 'Constants/ColorConstants.dart';
import 'FullScreenImage.dart';
import 'MySharedPreferences.dart';
import 'Utility.dart';
import 'dao/DatabaseHelper22.dart';
import 'dao/dio_upload_service.dart';
import 'dao/http_upload_service.dart';
import 'package:path/path.dart';
import 'loader.dart';
import 'model/Photo.dart';
import 'dashboard.dart';
import 'Constants/ApiConstant.dart';

class VerifyPage extends StatefulWidget {
  String? status, p_name;
  VerifyPage(this.status, this.p_name) : super();
  @override
  _VerifyPageState createState() => _VerifyPageState(status!, p_name!);
}

class _VerifyPageState extends State<VerifyPage>
    with SingleTickerProviderStateMixin {
  final HttpUploadService _httpUploadService = HttpUploadService();
  final ScrollController _scrollController = ScrollController();
  //final DioUploadService _dioUploadService = DioUploadService();
  String? status, p_name;
  //String img1,img2,img3;
  String? reg_id, name, mobile, uid;
  final dbHelper = DatabaseHelper22.instance;
  // Database dbHelper = DatabaseHelper22();
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  // String long = "", lat = "";
  String? loadlongitude;
  String? loadlatitude;
  String? long1;
  String? lat1;
  String? long2;
  String? lat2;
  String? long3;
  String? lat3;
  late StreamSubscription<Position> positionStream;
  //CameraDescription _cameraDescription;
  late List<String> _images = [];
  String? imagePath = '';
  String? base64String;
  String? selectedKhataNo, selectedPlotNo;
  bool isPressed = false;
  Color selectedPlotColor = const Color(0xff034B03);
  String? ref_ws;
  int? status4 = 0;
  int? maxStatus = 0;
  int? reportCount;
  String img22 =
      '/data/user/0/com.example.pmajg/app_flutter/f13585f2-eeaf-4716-9521-9a844ddb3e186441900169818777250.jpg';
  File? image1, image2, image3;
  String? loadImage1, loadImage2, loadImage3;
  String?
      loadName; // Name Text Box Load the first name and last name to this variable
  String? loadPhone; // Phone Text Box load the phone
  String? loadPassword; // Password Text Box load the password
  bool? visible = false;
  late List<Photo> images;
  late StreamController<int> streamController = new StreamController<int>();
  _VerifyPageState(this.status, this.p_name);
  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance
        .getStringValue("REG")
        .then((value) => setState(() {
              reg_id = value;
            }));
    MySharedPreferences.instance
        .getStringValue("UID")
        .then((value) => setState(() {
              uid = value;
              print('IDDD1 : $uid');
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
    images = [];
    refreshImages();
    checkGps();
    // availableCameras().then((cameras) {
    //   final camera = cameras
    //       .where((camera) => camera.lensDirection == CameraLensDirection.back)
    //       .toList()
    //       .first;
    //   setState(() {
    //     _cameraDescription = camera;
    //   });
    // }).catchError((err) {
    //   print(err);
    // });
  }

  Future sendImageToServer(BuildContext context) async {
    var url;
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
      //upload(fileName);
      //startUpload(fileName);
    });
    //url = ApiConstant.api1 + 'uploadImage.php' ;
    // SERVER LOGIN API URL
    if (status == '1') {
      url = ApiConstant.api1 + 'uploadImage1.php';
    }
    if (status == '2') {
      url = ApiConstant.api1 + 'uploadImage2.php';
    }
    if (status == '3') {
      url = ApiConstant.api1 + 'uploadImage3.php';
    }
    //Store all data with Param Name.
    var data = {
      'uid': uid,
      'image1': 'image1',
      'img1_lat': lat1,
      'img1_lang': long1,
      'image2': 'image2',
      'img2_lat': lat2,
      'img2_lang': long2,
      'image3': 'image3',
      'img3_lat': lat3,
      'img3_lang': long3
    };

    // Starting Web API Call.
    var response = await http.post(Uri.parse(url), body: data);
    print('IMG UPLOAD RESP :' + response.body.toString());
    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    print('SUCCESS ' + message);
    if (message == 'Success') {
      setState(() {
        visible = false;
      });

      // Navigate to Profile Screen & Sending Email to Next Screen.
      final snackBar = SnackBar(
        content: Text('${p_name!} Images Successfully Uploaded'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DashboardPage()));
      //Navigator.of(context).pushNamed(main_dsbd('Service'));

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
            title: new Text('Data Not save Successfully'),
            actions: <Widget>[
              TextButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  bool isLoading = true;
  void startTimer() {
    Timer.periodic(const Duration(seconds: 15), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    loadlongitude = position.longitude.toString();
    loadlatitude = position.latitude.toString();
    print('latlang :$loadlatitude $loadlongitude');
    print("Position : $position");
    setState(() {
      //refresh UI
      // lat1 = loadlatitude;
      // long1 = loadlongitude;
    });
    print('Long1 first : $long1');
    print('Lat1  first : $lat1');
  }

  Future<void> logoutUser(BuildContext context) async {
    MySharedPreferences.instance.removeAll();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserType()));
  }

  Future pickImage1(ImageSource source, BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      // temporary image
      // final imageTemporary = File(image.path);

      // permanent image
      final imagePermanent = await saveImagePermanently1(image.path);

      setState(() {
        // this.image = imageTemporary;
        this.image1 = imagePermanent;
        loadImage1 = imagePermanent.toString();
        // ignore: avoid_print
        print("Load Image : $loadImage1");
        Photo photo = Photo(0, loadImage1);
        dbHelper.save(photo);
        //Navigator.of(context).pop();
        print('Photo 1 : $photo');
        print('DbPhot : ${dbHelper.save(photo)}');
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }
  }

  Future<File> saveImagePermanently1(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future pickImage2(ImageSource source, BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      // temporary image
      // final imageTemporary = File(image.path);

      // permanent image
      final imagePermanent = await saveImagePermanently2(image.path);

      setState(() {
        // this.image = imageTemporary;
        this.image2 = imagePermanent;
        loadImage2 = imagePermanent.toString();
        // ignore: avoid_print
        print("Load Image : $loadImage2");
        //Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }
  }

  Future<File> saveImagePermanently2(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future pickImage3(ImageSource source, BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      // temporary image
      // final imageTemporary = File(image.path);

      // permanent image
      final imagePermanent = await saveImagePermanently3(image.path);

      setState(() {
        // this.image = imageTemporary;
        this.image3 = imagePermanent;
        loadImage3 = imagePermanent.toString();
        // ignore: avoid_print
        print("Load Image : $loadImage3");
        //Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Failed to pick image : $e');
    }
  }

  Future<File> saveImagePermanently3(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  _nameOnChanged(String? name) {
    loadName = name!.trim().toString().replaceAll(' ', '');
    // ignore: avoid_print
    print(loadName);
  }

  refreshImages() {
    dbHelper.getPhotos().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  gridView() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images.map((photo) {
          return Utility.imageFromBase64String(photo.image!);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('Rebuild');
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: Text(
          p_name ?? 'NA',
          style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
        backgroundColor: ColorConstants.kPrimaryColor,
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext bc) => [
              const PopupMenuItem(child: Text("Logout"), value: 0),
              // PopupMenuItem(
              //     child: Text("New Group Chat"), value: "/new-group-chat"),
              //PopupMenuItem(child: Text("Settings"), value: "/settings"),
            ],
            onSelected: (route) {
              if (route == 0) {
                logoutUser(context);
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
        width: double.infinity,
        height: double.infinity,
        child: Background(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.10),
            color: Colors.white,
            child: ListView(
              controller: _scrollController,
              // physics: NeverScrollableScrollPhysics(),
              children: [
                // gridView(),

                // Container(
                //   child: image1 != null
                //       ? Image.file(
                //           //File('img22'),
                //           image1!,
                //           fit: BoxFit.cover,
                //         )
                //       : Image.asset(
                //           "assets/images/placeholder.png",
                //           fit: BoxFit.cover,
                //         ),
                // ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Attach Three Images \n For ' + p_name!,
                      style: const TextStyle(
                        fontSize: 22,
                        color: ColorConstants.kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 24.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  width: double.infinity,
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Image One',
                        style: TextStyle(
                          color: ColorConstants.kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        fit: StackFit.passthrough,
                        children: [
                          Container(
                            height: size.height * 0.20,
                            width: size.width,
                            // margin: const EdgeInsets.only(left: 50, right: 50),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 0.0,
                                  blurRadius: 6.0,
                                  offset: Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenImage(image1, 'Image One')),
                                );
                              },
                              child: Container(
                                child: image1 != null
                                    ? Image.file(
                                        //File('img22'),
                                        image1!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/images/placeholder.png",
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: InkWell(
                              onTap: () {
                                pickImage1(ImageSource.camera, context)
                                    .then((value) {
                                  setState(() {
                                    print('Print : ${value.toString()}');
                                    long1 = loadlongitude;
                                    lat1 = loadlatitude;
                                  });
                                });
                              },
                              // onTap: () =>
                              //     pickImage1(ImageSource.camera, context)
                              //         .then((value) {
                              //   setState(() {
                              //     checkGps();
                              //   });

                              //   // long1 = loadlongitude;
                              //   // lat1 = loadlatitude;
                              //   print('Long1 : $long1');
                              //   print('Lat1 : $lat1');
                              // }),
                              // takePhoto(ImageSource.camera);

                              child: CircleAvatar(
                                radius: size.height * 0.024,
                                backgroundColor: ColorConstants.kPrimaryColor,
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(height: 24.0),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  width: double.infinity,
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Image Two',
                        style: TextStyle(
                          color: ColorConstants.kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        fit: StackFit.passthrough,
                        children: [
                          Container(
                            height: size.height * 0.20,
                            width: size.width,
                            // margin: const EdgeInsets.only(left: 50, right: 50),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 0.0,
                                  blurRadius: 6.0,
                                  offset: Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenImage(image2, 'Image Two')),
                                );
                              },
                              child: Container(
                                child: image2 != null
                                    ? Image.file(
                                        //File('img22'),
                                        image2!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/images/placeholder.png",
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: InkWell(
                              onTap: () =>
                                  pickImage2(ImageSource.camera, context)
                                      .then((value) {
                                setState(() {
                                  checkGps();
                                  long2 = loadlongitude;
                                  lat2 = loadlatitude;
                                  print('Long : $long2');
                                  print('Lat : $lat2');
                                });
                              }),
                              // takePhoto(ImageSource.camera);

                              child: CircleAvatar(
                                radius: size.height * 0.024,
                                backgroundColor: ColorConstants.kPrimaryColor,
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 24.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  width: double.infinity,
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Image Three',
                        style: TextStyle(
                          color: ColorConstants.kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        fit: StackFit.passthrough,
                        children: [
                          Container(
                            height: size.height * 0.20,
                            width: size.width,
                            // margin: const EdgeInsets.only(left: 50, right: 50),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 0.0,
                                  blurRadius: 6.0,
                                  offset: Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullScreenImage(
                                          image3, 'Image Three')),
                                );
                              },
                              child: Container(
                                child: image3 != null
                                    ? Image.file(
                                        //File('img22'),
                                        image3!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/images/placeholder.png",
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: InkWell(
                              onTap: () =>
                                  pickImage3(ImageSource.camera, context)
                                      .then((value) {
                                setState(() {
                                  checkGps();
                                  long3 = loadlongitude;
                                  lat3 = loadlatitude;
                                  print('Long : $long3');
                                  print('Lat : $lat3');
                                });
                              }),
                              // takePhoto(ImageSource.camera);

                              child: CircleAvatar(
                                radius: size.height * 0.024,
                                backgroundColor: ColorConstants.kPrimaryColor,
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Container(
                //   padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                //   //child:Expanded(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(left: 12.0),
                //         child: Text(
                //           'Image Two',
                //           style: TextStyle(
                //             color: ColorConstants.kPrimaryColor,
                //             fontSize: 16,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //       InkWell(
                //         onTap: () => pickImage2(ImageSource.camera, context),
                //         // takePhoto(
                //         // Source.camera);

                //         child: CircleAvatar(
                //           radius: size.height * 0.024,
                //           backgroundColor: ColorConstants.kPrimaryColor,
                //           child: Icon(
                //             Icons.camera_alt_rounded,
                //             color: Colors.white,
                //             size: 18,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                //   //),
                //   //),
                // ),
                // Container(
                //   height: size.height * 0.20,
                //   width: size.height * 0.18,
                //   margin: const EdgeInsets.only(left: 50, right: 50),
                //   clipBehavior: Clip.antiAliasWithSaveLayer,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.rectangle,
                //     border: Border.all(
                //       color: Colors.white,
                //       width: 4.0,
                //     ),
                //     boxShadow: const [
                //       BoxShadow(
                //         color: Colors.black26,
                //         spreadRadius: 0.0,
                //         blurRadius: 6.0,
                //         offset: Offset(0.0, 2.0),
                //       ),
                //     ],
                //   ),
                //   child: GestureDetector(
                //     onTap: () async {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) =>
                //                 FullScreenImage(image2, 'Image Two')),
                //       );
                //     },
                //     child: Container(
                //       child: image2 != null
                //           ? Image.file(
                //               image2!,
                //               fit: BoxFit.cover,
                //             )
                //           : Image.asset(
                //               "assets/images/placeholder.png",
                //               fit: BoxFit.cover,
                //             ),
                //     ),
                //   ),
                // ),
                // const Divider(height: 24.0),
                // Container(
                //   padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                //   //child:Expanded(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Padding(
                //         padding: EdgeInsets.only(left: 12.0),
                //         child: Text(
                //           'Image Three',
                //           style: TextStyle(
                //             color: ColorConstants.kPrimaryColor,
                //             fontSize: 16,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //       InkWell(
                //         onTap: () => pickImage3(ImageSource.camera, context),
                //         // takePhoto(ImageSource.camera);

                //         child: CircleAvatar(
                //           radius: size.height * 0.024,
                //           backgroundColor: ColorConstants.kPrimaryColor,
                //           child: const Icon(
                //             Icons.camera_alt_rounded,
                //             color: Colors.white,
                //             size: 18,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                //   //),
                // ),
                // Container(
                //   height: size.height * 0.20,
                //   width: size.height * 0.18,
                //   margin: const EdgeInsets.only(left: 50, right: 50),
                //   clipBehavior: Clip.antiAliasWithSaveLayer,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.rectangle,
                //     border: Border.all(
                //       color: Colors.white,
                //       width: 4.0,
                //     ),
                //     boxShadow: const [
                //       BoxShadow(
                //         color: Colors.black26,
                //         spreadRadius: 0.0,
                //         blurRadius: 6.0,
                //         offset: Offset(0.0, 2.0),
                //       ),
                //     ],
                //   ),
                //   child: GestureDetector(
                //     onTap: () async {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) =>
                //                 FullScreenImage(image3, 'Image Three')),
                //       );
                //     },
                //     child: Container(
                //       child: image3 != null
                //           ? Image.file(
                //               image3!,
                //               fit: BoxFit.cover,
                //             )
                //           : Image.asset(
                //               "assets/images/placeholder.png",
                //               fit: BoxFit.cover,
                //             ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 24.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 16.0),
                  // height: 70,
                  //padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    // color: Colors.indigo,
                    gradient: LinearGradient(colors: [
                      ColorConstants.kPrimaryUltraLightColor,
                      ColorConstants.kPrimaryUltraLightColor
                    ]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Longitude: $loadlongitude",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.kPrimaryColor),
                      ),
                      Text(
                        "Latitude: $loadlatitude",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.kPrimaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.0,
                      margin: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Image.asset('assets/images/image-2.jpeg'),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Text(
                          'Download GPS camera from the link provided and upload the photographs using GPS details',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Container(
                    //padding: const EdgeInsets.all(10.0),
                    child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 16.0),
                  // color: ColorConstants.kPrimaryColor,
                  child: MaterialButton(
                    elevation: 2.0,
                    color: ColorConstants.kPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    ColorConstants.kPrimaryColor),
                              ),
                            );
                          });
                      startTimer();
                      sendImageToServer(context);
                      // Navigator.of(context)
                      //     .pushReplacement(MaterialPageRoute(builder: (context) => DashboardPage()));
                    },
                    child: const Text(
                      'SAVE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     margin: const EdgeInsets.all(5),
                //     width: double.infinity,
                //     child: ElevatedButton(
                //       onPressed: () {},
                //       child: const Text('SAVE '),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
