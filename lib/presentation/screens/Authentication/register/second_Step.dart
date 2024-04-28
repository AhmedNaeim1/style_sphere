import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart' as datePicker;
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/buttons.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/textFields.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

// ignore: must_be_immutable
class SecondStep extends StatefulWidget {
  String name;

  SecondStep({
    super.key,
    required this.name,
  });

  @override
  State<SecondStep> createState() => _SecondStepState();
}

class _SecondStepState extends State<SecondStep> {
  final TextEditingController _dateOfBirthController = TextEditingController();
  String errorMessage = '';
  bool errorDateOfBirth = false;
  bool buttonColor = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar("Register", context, 20.sp),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/authentication/emailRegister2.png"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: buildCustomText(
                                text: "2/3",
                                fontSize: 10,
                                color: grey20Color,
                                align: TextAlign.center,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            buildSizedBox(3.h),
                            buildCustomText(
                              text:
                                  "Hey ${widget.name.split(" ")[0]}, what’s your date of birth?",
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              color: darkBlueColor,
                            ),
                            buildSizedBox(1.h),
                            buildCustomText(
                                text:
                                    "We need this to keep StyleSphere a safe space",
                                fontSize: 10,
                                color: greyBlueColor),
                            buildSizedBox(5.h),
                            buildTextFieldSection(
                              "Date of Birth",
                              _dateOfBirthController,
                              "22 October 2003",
                              false,
                              errorDateOfBirth,
                              (value) {
                                // if (_dateOfBirthController.text.isNotEmpty &&
                                //     DateTime.now().difference(
                                //             DateFormat('dd MMMM yyyy').parse(
                                //                 _dateOfBirthController.text)) >
                                //         const Duration(days: 4745)) {
                                //   setState(() {
                                //     buttonColor = true;
                                //   });
                                // } else {
                                //   setState(() {
                                //     buttonColor = false;
                                //   });
                                // }
                              },
                            ),
                            buildErrorText(
                              text: errorMessage,
                            ),
                            buildSizedBox(4.h),
                            datePicker.Picker(
                              hideHeader: true,
                              adapter: datePicker.DateTimePickerAdapter(
                                type: datePicker.PickerDateTimeType.kYMD,
                                isNumberMonth: false,
                                yearSuffix: " ",
                                minValue: DateTime(1900, 1, 1),
                                maxValue: DateTime.now(),
                                yearBegin: 1900,
                                yearEnd: DateTime.now().year,
                                customColumnType: [2, 1, 0],
                              ),
                              selectedTextStyle: TextStyle(color: blackColor),
                              containerColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              height: 20.h,
                              squeeze: 0.6,
                              onSelect: (datePicker.Picker picker, int index,
                                  List<int> selected) {
                                final selectedDate = DateTime(
                                    int.parse(
                                        picker.adapter.text.split("-")[0]),
                                    int.parse(
                                        picker.adapter.text.split("-")[1]),
                                    int.parse(picker.adapter.text
                                        .split("-")[2]
                                        .split(" ")[0]));
                                final formattedDate = DateFormat('dd MMMM yyyy')
                                    .format(selectedDate);
                                _dateOfBirthController.text = formattedDate;
                              },
                            ).makePicker(),
                            const Spacer(),
                            CustomElevatedButton(
                              text: 'Continue',
                              onPressed: () {
                                if (_dateOfBirthController.text.isEmpty) {
                                  setState(
                                    () {
                                      errorMessage =
                                          "Choose your date of birth to continue";
                                      errorDateOfBirth = true;
                                    },
                                  );
                                } else if (DateTime.now().difference(
                                        DateFormat('dd MMMM yyyy').parse(
                                            _dateOfBirthController.text)) <
                                    const Duration(days: 4745)) {
                                  setState(
                                    () {
                                      errorMessage =
                                          "You must be at least 13 years old to use StyleSphere";
                                      errorDateOfBirth = true;
                                    },
                                  );
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.thirdStep,
                                    arguments: {
                                      'name': widget.name,
                                      'dob': _dateOfBirthController.text
                                          .toString(),
                                    },
                                  );
                                }
                              },
                              color: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
