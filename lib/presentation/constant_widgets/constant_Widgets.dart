import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/checkout_cubits/payment_cubit.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/checkout/payment_data.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';
import 'package:style_sphere/presentation/functions/constant_functions.dart';

Widget buildSizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

Column buildPasswordInfoRow(
    String text, bool followsRules, TextEditingController controller) {
  Color iconColor = controller.text.isEmpty
      ? greyColor
      : followsRules
          ? greenColor
          : redColor;
  return Column(
    children: [
      Row(
        children: [
          Icon(
            Icons.info_outline,
            color: iconColor,
            size: 14.sp,
          ),
          SizedBox(
            width: 1.w,
          ),
          buildCustomTextGabarito(
            text: text,
            fontSize: 10,
            color: iconColor,
          ),
        ],
      ),
      buildSizedBox(0.5.h),
    ],
  );
}

Widget buildSettingsRow(
  String text,
  String imageIconPath, // SVG icon path as a string
  BuildContext context,
  String routeName,
  dynamic arguments,
) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
      child: Row(
        children: [
          SizedBox(
            width: 18.sp,
            height: 18.sp,
            child: Image.asset(
              fit: BoxFit.fitHeight,
              imageIconPath,
            ),
          ),
          SizedBox(width: 4.w),
          buildCustomTextGabarito(
            text: text,
            color: grey80Color,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: blackColor,
            size: 12.sp,
          ),
        ],
      ),
    ),
  );
}

Widget buildEditProfileRow(String labelText, String routeName,
    BuildContext context, dynamic arguments) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildCustomTextGabarito(
          text: labelText,
          color: Colors.black,
          fontSize: 11,
          align: TextAlign.left,
          fontWeight: FontWeight.normal,
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 15,
        )
      ],
    ),
  );
}

Widget buildLanguageCurrencyTile({
  required String languageName,
  required String languageValue,
  required String selectedLanguage,
  required void Function(String) onChanged,
}) {
  bool isSelected = selectedLanguage == languageValue;

  return ListTile(
    onTap: () {
      onChanged(languageValue);
    },
    title: buildCustomTextGabarito(
      text: languageName,
      color: blackColor,
      fontSize: 12,
      align: TextAlign.left,
      fontWeight: FontWeight.normal,
    ),
    trailing: Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(
                color: Colors.transparent,
              )
            : Border.all(
                color: Colors.black,
                width: 1.5,
              ),
        color: isSelected ? const Color(0xff4AC76D) : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 18.0,
              color: Colors.white,
            )
          : null,
    ),
  );
}

Widget buildRegionTile({
  required String regionName,
  required String regionValue,
  required String selectedRegion,
  required String imageIconPath,
  required void Function(String) onChanged,
}) {
  bool isSelected = selectedRegion == regionValue;

  return ListTile(
    onTap: () {
      onChanged(regionValue);
    },
    leading: SizedBox(
      width: 22.sp,
      height: 22.sp,
      child: Image.asset(
        fit: BoxFit.fitHeight,
        imageIconPath,
      ),
    ),
    title: buildCustomTextGabarito(
      text: regionName,
      color: blackColor,
      fontSize: 12,
      align: TextAlign.left,
      fontWeight: FontWeight.normal,
    ),
    trailing: Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(
                color: Colors.transparent,
              )
            : Border.all(
                color: Colors.black,
                width: 1.5,
              ),
        color: isSelected ? const Color(0xff4AC76D) : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 18.0,
              color: Colors.white,
            )
          : null,
    ),
  );
}

Widget buildSavedCards(PaymentData payment, int index, BuildContext context,
    bool paymentPage, String userID, PaymentCubit paymentCubit) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      image: DecorationImage(
        image: AssetImage("assets/settings/savedCards${index + 1}.png"),
        fit: BoxFit.fitWidth,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomTextInter(
                text: payment.name!,
                color: Colors.white,
                fontSize: 14,
              ),
              Image.asset(
                "assets/settings/visa.png",
                fit: BoxFit.fitHeight,
              ),
            ],
          ),
          buildSizedBox(5.h),
          buildCustomTextInter(
            text: "Visa Classic",
            color: Colors.white,
            fontSize: 12,
          ),
          buildCustomTextInter(
            text: formatCardNumber(payment.cardNumber.toString()),
            color: Colors.white,
            fontSize: 16,
            align: TextAlign.left,
            fontWeight: FontWeight.normal,
          ),
          paymentPage
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text(
                                  'Are you sure you want to delete this card?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    paymentCubit.deletePayment(
                                        payment.paymentMethodID!, userID);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Yes',
                                      style: TextStyle(color: greenColor)),
                                ),
                                const SizedBox(
                                    height: 30,
                                    child: VerticalDivider(
                                        color: Colors.black, thickness: 1)),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('No',
                                      style: TextStyle(color: redColor)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete, color: redColor),
                    ),
                  ],
                ),
        ],
      ),
    ),
  );
}
