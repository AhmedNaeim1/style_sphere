import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/checkout_cubits/payment_cubit.dart';
import 'package:style_sphere/data/models/checkout/payment_data.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/buttons.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/textFields.dart';

// ignore: must_be_immutable
class AddCard extends StatefulWidget {
  final String userID;
  final int paymentMethodID;

  // final String page;

  const AddCard({
    super.key,
    required this.userID,
    required this.paymentMethodID,
    // required this.page
  });

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();

  final TextEditingController _cvvController = TextEditingController();

  bool buttonColor = false;
  bool errorFirstName = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar("Add New Card", context, 12.sp),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextFieldSection("Card Owner", _nameController,
                              "John Doe", true, errorFirstName, (value) {}),
                          buildSizedBox(2.h),
                          buildTextFieldSection(
                            "Card Number",
                            _cardNumberController,
                            "1234 5678 1234 5678",
                            true,
                            errorFirstName,
                            (value) {
                              if (value.length == 4 ||
                                  value.length == 9 ||
                                  value.length == 14) {
                                _cardNumberController.text = value + " ";
                                _cardNumberController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                            _cardNumberController.text.length));
                              }
                              if (value.length > 19) {
                                _cardNumberController.text =
                                    value.substring(0, value.length - 1);
                                _cardNumberController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                            _cardNumberController.text.length));
                              }
                            },
                          ),
                          buildSizedBox(2.h),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextFieldSection(
                                    "EXP",
                                    _expController,
                                    "06/24",
                                    true,
                                    errorFirstName, (value) {
                                  if (value.length == 2) {
                                    _expController.text = value + "/";
                                    _expController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                _expController.text.length));
                                  }
                                  if (value.length > 5) {
                                    _expController.text =
                                        value.substring(0, value.length - 1);
                                    _expController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                _expController.text.length));
                                  }
                                }),
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Expanded(
                                child: buildTextFieldSection(
                                    "CVV",
                                    _cvvController,
                                    "123",
                                    true,
                                    errorFirstName, (value) {
                                  if (value.length > 3) {
                                    _cvvController.text =
                                        value.substring(0, value.length - 1);
                                    _cvvController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                _cvvController.text.length));
                                  }
                                }),
                              ),
                            ],
                          ),
                          const Spacer(),
                          CustomElevatedButton(
                            text: 'Add Card',
                            onPressed: () {
                              if (_nameController.text.isNotEmpty &&
                                  _cardNumberController.text.isNotEmpty &&
                                  _expController.text.isNotEmpty &&
                                  _cvvController.text.isNotEmpty) {
                                print(_cardNumberController.text
                                    .split(" ")
                                    .join(""));
                                PaymentData paymentData = PaymentData(
                                  name: _nameController.text,
                                  cardNumber: _cardNumberController.text
                                      .split(" ")
                                      .join(""),
                                  expirationDate: _expController.text,
                                  userID: widget.userID,
                                  paymentMethodID: widget.paymentMethodID,
                                );
                                PaymentCubit.get(context)
                                    .addPayment(paymentData);

                                Navigator.pop(context);
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
            );
          },
        ),
      ),
    );
  }
}
