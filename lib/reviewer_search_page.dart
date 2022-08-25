// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pmayg/Constants/ColorConstants.dart';
import 'package:pmayg/Widgets/rounded_button_widget.dart';
import 'package:pmayg/Widgets/textformfield_widget.dart';
import 'package:pmayg/dashboard.dart';
import 'package:pmayg/reviewer_dashboard.dart';

class ReviewerSearchPage extends StatefulWidget {
  const ReviewerSearchPage({Key? key}) : super(key: key);

  @override
  State<ReviewerSearchPage> createState() => _ReviewerSearchPageState();
}

class _ReviewerSearchPageState extends State<ReviewerSearchPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.kPrimaryColor,
          centerTitle: true,
          title: const Text('Search Beneficiary'),
        ),
        body: Container(
          width: double.infinity,
          height: size.height,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          // color: Colors.deepPurple[200],
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: size.width * 0.8,
                    child: Image.asset(
                      'assets/images/image-8.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  TextFormFieldWidget(
                    controller: _searchController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    label: "Search",
                    labelColor: ColorConstants.kPrimaryColor.withAlpha(160),
                    borderColor: ColorConstants.kPrimaryUltraLightColor,
                    bgColor: ColorConstants.kPrimaryUltraLightColor,
                    inputType: TextInputType.text,
                    validator: _searchValidator,
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                  SizedBox(height: size.height * 0.018),
                  SizedBox(
                    height: size.height * 0.056,
                    child: RoundedButtonWidget(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print('Success');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReviewerDashboard(),
                            ),
                          );
                        } else {
                          print('Error');
                        }
                      },
                      label: 'Seach Beneficiary',
                      bgColor: ColorConstants.kPrimaryColor,
                      labelColor: Colors.white,
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _searchValidator(String? value) {
    if (value!.isEmpty) {
      return 'Required';
    } else {
      return null;
    }
  }
}
