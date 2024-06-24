import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/blocs/checkout_blocs/shipment_state.dart';
import 'package:style_sphere/businessLogic/cubits/checkout_cubits/shipment_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/data/repositories/checkout_repository/shipment_repository.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

class SavedAddress extends StatefulWidget {
  final UserData user;
  final String? page;

  const SavedAddress({super.key, required this.user, this.page});

  @override
  State<SavedAddress> createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShippingCubit>(
      create: (context) => ShippingCubit(repository: ShippingRepository())
        ..getUserShipments(widget.user.userID!),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildLeadingAppBar(
              "Saved Addresses", context, 12.sp, widget.user,
              page: widget.page),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/settings/editProfile.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
              ),
            ),
            child: BlocBuilder<ShippingCubit, ShipmentState>(
              builder: (context, state) {
                if (state is ShipmentLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ShipmentLoadedState) {
                  return SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraint) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minHeight: constraint.maxHeight),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18.0, 10, 18, 18),
                                child: Column(
                                  children: [
                                    state.shipments.isEmpty
                                        ? Center(
                                            child: buildCustomTextGabarito(
                                              text: "No saved address yet",
                                              color: blackColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 3,
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: List.generate(
                                                  state.shipments.length,
                                                  (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        if (widget.page ==
                                                            "home") {
                                                          Navigator.pop(
                                                              context, {
                                                            "selectedAddress":
                                                                state.shipments[
                                                                    index]
                                                          });
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  buildCustomTextGabarito(
                                                                text: state
                                                                    .shipments[
                                                                        index]
                                                                    .shippingAddress
                                                                    .toString(),
                                                                color:
                                                                    greyColor,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            IconButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      content:
                                                                          const Text(
                                                                              'Are you sure you want to delete this address?'),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            BlocProvider.of<ShippingCubit>(context).deleteShipment(state.shipments[index].shippingAddressID!,
                                                                                widget.user.userID!);
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: Text(
                                                                              'Yes',
                                                                              style: TextStyle(color: greenColor)),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                VerticalDivider(color: Colors.black, thickness: 1)),
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.of(context).pop(),
                                                                          child: Text(
                                                                              'No',
                                                                              style: TextStyle(color: redColor)),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              icon: Icon(
                                                                  Icons.delete,
                                                                  color:
                                                                      redColor),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 6.h,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: whiteColor,
                                            side: BorderSide(
                                                color:
                                                    state.shipments.length < 3
                                                        ? primaryColor
                                                        : grey20Color,
                                                width: 1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (state.shipments.length < 3) {
                                              Navigator.pushNamed(
                                                  context, AppRoutes.addAddress,
                                                  arguments: {
                                                    "user":
                                                        jsonEncode(widget.user),
                                                    "shipmentMethodID":
                                                        state.shipments.length +
                                                            1
                                                  });
                                            }
                                          },
                                          child: buildCustomTextInter(
                                            text: '+ Add New Address',
                                            color: state.shipments.length < 3
                                                ? primaryColor
                                                : grey20Color,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is ShipmentErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCustomTextGabarito(
                          text: "Error",
                          color: blackColor,
                          fontSize: 16,
                          align: TextAlign.left,
                          fontWeight: FontWeight.normal,
                        ),
                        buildSizedBox(2.h),
                        buildCustomTextGabarito(
                          text: "An error occurred",
                          color: blackColor,
                          fontSize: 16,
                          align: TextAlign.left,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
