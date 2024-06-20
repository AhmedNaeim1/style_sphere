import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:style_sphere/businessLogic/cubits/user_cubit.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/presentation/constant_widgets/appBars.dart';
import 'package:style_sphere/presentation/constant_widgets/constant_Widgets.dart';

class RegionPage extends StatefulWidget {
  final String region;
  final UserData user;

  const RegionPage({
    super.key,
    required this.region,
    required this.user,
  });

  @override
  State<RegionPage> createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  late String selectedRegion = widget.region;
  List<String> countries = ["Egypt", "UAE", "United Kingdom", "Kuwait"];

  @override
  void initState() {
    super.initState();
    selectedRegion = widget.region;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<userCubit>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildLeadingAppBar("Region", context, 14.sp, widget.user),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/settings/editProfile.png"),
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildSizedBox(4.h),
              Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildRegionTile(
                        regionName: widget.region,
                        regionValue: widget.region,
                        selectedRegion: selectedRegion,
                        onChanged: (String value) {
                          setState(() {
                            selectedRegion = value;
                            widget.user.regionPreference = value;
                          });
                          cubit.updateUser(
                            widget.user.userID!,
                            widget.user,
                          );
                        },
                        imageIconPath: 'assets/${widget.region}.png',
                      ),
                      const Divider(),
                      for (int i = 0; i < countries.length; i++)
                        if (countries[i] != widget.region)
                          buildRegionTile(
                            regionName: countries[i],
                            regionValue: countries[i],
                            selectedRegion: selectedRegion,
                            onChanged: (String value) {
                              setState(() {
                                selectedRegion = value;
                                widget.user.regionPreference = value;
                              });
                              cubit.updateUser(
                                widget.user.userID!,
                                widget.user,
                              );
                            },
                            imageIconPath: 'assets/${countries[i]}.png',
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
