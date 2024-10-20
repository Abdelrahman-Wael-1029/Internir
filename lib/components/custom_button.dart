import 'package:flutter/material.dart';
import '../utils/app_color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? borderColor;
  final EdgeInsets? padding;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final bool isDisable;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.isDisable = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isDisable ? null : onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: isDisable ? AppColor.grey1 : backgroundColor,
            padding: EdgeInsets.zero,
            side: BorderSide(color: borderColor ?? Colors.transparent),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 15),
                side: BorderSide(color: borderColor ?? Colors.transparent)),
            shadowColor: Colors.transparent),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize ?? 16,
              fontWeight: fontWeight ?? FontWeight.w500,
              fontFamily: 'NotoSans',
            ),
          ),
        ),
      ),
    );
  }
}