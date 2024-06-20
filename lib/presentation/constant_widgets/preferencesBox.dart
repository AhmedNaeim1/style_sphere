import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/presentation/constant_widgets/texts.dart';

class CustomPreferenceBox extends StatefulWidget {
  final String text;
  final bool isClicked;
  final ValueChanged<bool> onChanged;
  final String image;
  final int index;

  const CustomPreferenceBox({
    super.key,
    required this.text,
    required this.isClicked,
    required this.onChanged,
    required this.image,
    required this.index,
  });

  @override
  _CustomPreferenceBoxState createState() => _CustomPreferenceBoxState();
}

class _CustomPreferenceBoxState extends State<CustomPreferenceBox> {
  List<String> type = [
    'Tshirts',
    'Shirts',
    'Casual Shoes',
    'Watches',
    'Sports Shoes',
    'Tops',
    'Handbags',
    'Heels',
    'Sunglasses',
    'Wallets',
    'Flip Flops',
    'Sandals',
    'Belts'
  ];

  List<String> season = [
    'Spring',
    'Summer',
    'Fall',
    'Winter',
  ];

  List<String> styles = [
    "Casual",
    "Sports",
    "Formal",
    "Party",
    "Smart Casual",
    "Travel",
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Notify the parent about the state change
        widget.onChanged(!widget.isClicked);
      },
      child: Container(
        height: 10.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isClicked ? primaryColor : grey20Color,
            width: 3,
          ),
          image: DecorationImage(
            image: AssetImage(widget.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: buildCustomTextGabarito(
              text: widget.text == "Material"
                  ? type[widget.index]
                  : widget.text == "Occasion"
                      ? season[widget.index]
                      : styles[widget.index],
              color: grey20Color,
              align: TextAlign.end,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
