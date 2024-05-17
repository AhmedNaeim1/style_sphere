import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/blocs/checkout_blocs/payment_state.dart';
import 'package:style_sphere/businessLogic/cubits/checkout_cubits/payment_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/repositories/checkout_repository/payment_repository.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/router.dart';

class SavedCards extends StatefulWidget {
  final String userID;

  const SavedCards({super.key, required this.userID});

  @override
  State<SavedCards> createState() => _SavedCardsState();
}

class _SavedCardsState extends State<SavedCards> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentCubit>(
      create: (context) => PaymentCubit(repository: PaymentRepository())
        ..getUserPayments(widget.userID),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar("Saved Cards", context, 12.sp),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/settings/editProfile.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
              ),
            ),
            child: BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                if (state is PaymentLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PaymentLoadedState) {
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
                                    state.payments.isEmpty
                                        ? Center(
                                            child: buildCustomTextGabarito(
                                              text: "No saved cards yet",
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
                                                  state.payments.length,
                                                  (index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: buildSavedCards(
                                                          state.payments[index],
                                                          index,
                                                          context,
                                                          false,
                                                          widget.userID,
                                                          PaymentCubit.get(
                                                              context)),
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
                                                color: state.payments.length < 3
                                                    ? primaryColor
                                                    : grey20Color,
                                                width: 1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (state.payments.length < 3) {
                                              Navigator.pushNamed(
                                                  context, AppRoutes.addCard,
                                                  arguments: {
                                                    "userID": widget.userID,
                                                    "paymentMethodID":
                                                        state.payments.length +
                                                            1
                                                  });
                                            }
                                          },
                                          child: buildCustomTextInter(
                                            text: '+ Add New Card',
                                            color: state.payments.length < 3
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
                } else if (state is PaymentErrorState) {
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
