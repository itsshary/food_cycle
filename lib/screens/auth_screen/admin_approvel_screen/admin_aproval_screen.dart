import 'package:flutter/material.dart';
import 'package:food_cycle/utils/app_constants.dart';
import 'package:food_cycle/utils/app_textstyle.dart';
import 'package:food_cycle/routes/routes_name.dart';
import 'package:food_cycle/utils/color_resources.dart';

class AdminAprovalScreen extends StatefulWidget {
  const AdminAprovalScreen({super.key});

  @override
  State<AdminAprovalScreen> createState() => _AdminAprovalScreenState();
}

class _AdminAprovalScreenState extends State<AdminAprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              AppConstants.approval,
              style: AppTextstyle().commontextstylebalckcolor,
            ),
          ),
          BackButton(
            color: ColorResources.whiteColor,
            onPressed: () {
              Navigator.pushNamed(context, Routesname.loginScreen);
            },
            style: const ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(ColorResources.primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
