import 'package:flutter/material.dart';
import 'package:internir/utils/app_color.dart';
import 'package:internir/utils/size_config.dart';

// ignore: must_be_immutable
class CustomSearch extends StatelessWidget {
  Function(String)? onChanged;
  String? hintText;
  Color? color;
  TextEditingController? controller;

  CustomSearch({super.key, 
    this.onChanged,
    this.hintText,
    this.color,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.horizontalBlock * 8,
      ),
      // height: SizeConfig.verticalBlock * 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: color ?? AppColor.grey1,
        ),
      ),
      child: TextField(
        style: TextStyle(
          color: color,
          fontFamily: "GretaArabic",
          fontSize: SizeConfig.textRatio * 16,
          fontWeight: FontWeight.w300,
        ),
        cursorColor: AppColor.black,
        controller: controller,
        decoration: InputDecoration(
          // isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: color,
            fontFamily: "GretaArabic",
            fontSize: SizeConfig.textRatio * 16,
            fontWeight: FontWeight.w300,
          ),
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
