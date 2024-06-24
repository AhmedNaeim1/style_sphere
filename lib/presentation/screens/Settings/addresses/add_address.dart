import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/business_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/checkout_cubits/shipment_cubit.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/data/models/business_data.dart';
import 'package:style_sphere/data/models/checkout/shipment_data.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/buttons.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/textFields.dart';
import 'package:style_sphere/presentation/router.dart';

// ignore: must_be_immutable
class AddAddress extends StatefulWidget {
  final UserData user;
  int? shipmentMethodID;

  String? page;

  AddAddress({super.key, required this.user, this.shipmentMethodID, this.page});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _cityController = TextEditingController();

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
        appBar: buildAppBar(
            widget.page == null ? "Add New Address" : "Billing Address",
            context,
            12.sp),
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
                          buildTextFieldSection("Name", _nameController,
                              "Home Villa", true, errorFirstName, (value) {}),
                          buildSizedBox(2.h),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextFieldSection(
                                    "Country",
                                    _countryController,
                                    "Egypt",
                                    true,
                                    errorFirstName,
                                    (value) {}),
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Expanded(
                                child: buildTextFieldSection(
                                    "City",
                                    _cityController,
                                    "Giza",
                                    true,
                                    errorFirstName,
                                    (value) {}),
                              ),
                            ],
                          ),
                          buildTextFieldSection(
                            "Phone Number",
                            _phoneNumberController,
                            "+91-800 301 0108",
                            true,
                            errorFirstName,
                            (value) {},
                          ),
                          buildSizedBox(2.h),
                          buildTextFieldSection(
                            "Address",
                            _addressController,
                            "43, Electronics City Phase 1, Electronic City",
                            true,
                            errorFirstName,
                            (value) {},
                          ),
                          buildSizedBox(2.h),
                          const Spacer(),
                          CustomElevatedButton(
                            text: 'Save Address',
                            onPressed: () {
                              if (widget.page == null) {
                                if (_nameController.text.isNotEmpty &&
                                    _addressController.text.isNotEmpty &&
                                    _countryController.text.isNotEmpty &&
                                    _cityController.text.isNotEmpty &&
                                    _phoneNumberController.text.isNotEmpty) {
                                  final ShipmentModel shipmentData =
                                      ShipmentModel(
                                    shippingAddressID: widget.shipmentMethodID,
                                    userID: widget.user.userID,
                                    name: _nameController.text,
                                    shippingAddress: _addressController.text,
                                    city: _cityController.text,
                                    country: _countryController.text,
                                    phoneNumber: _phoneNumberController.text,
                                  );

                                  ShippingCubit.get(context)
                                      .addShipment(shipmentData);

                                  Navigator.pop(context);
                                }
                              } else {
                                if (_nameController.text.isNotEmpty &&
                                    _addressController.text.isNotEmpty &&
                                    _countryController.text.isNotEmpty &&
                                    _cityController.text.isNotEmpty &&
                                    _phoneNumberController.text.isNotEmpty) {
                                  final BusinessModel businessData =
                                      BusinessModel(
                                    businessID: widget.user.userID,
                                    userID: widget.user.userID,
                                    businessName: widget.user.name,
                                    bio: "About my business",
                                    contactInfo: _phoneNumberController.text,
                                    billingAddress: _addressController.text,
                                    businessCategory: "Category",
                                    businessUrl: "https://example.com",
                                    dateCreated: DateTime.now(),
                                  );

                                  BusinessCubit.get(context)
                                      .createBusiness(businessData);
                                  setState(() {
                                    widget.user.businessID = widget.user.userID;
                                  });
                                  userCubit.get(context).updateUser(
                                      widget.user.userID!, widget.user);

                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.addProduct,
                                    arguments: json.encode(widget.user),
                                  );
                                }
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
