import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import '../utils/size_config.dart';

Widget customTextFormField({
  String? hintText,
  String? Function(String?)? validator,
  TextEditingController? controller,
  bool obscureText = false,
  TextInputType? keyboardType,
  Widget? suffixIcon,
  Widget? prefixIcon,
  bool readOnly = false,
  bool enabled = true,
  bool autofocus = false,
  int minLines = 1,
  int maxLines = 1,
  void Function(String)? onChanged,
  void Function()? onTap,
  void Function(String)? onFieldSubmitted,
  void Function(String?)? onSaved,
  void Function()? onEditingComplete,
  Color? hintColor,
}) {
  return TextFormField(
    style: TextStyle(
      fontSize: 16 * SizeConfig.textRatio,
      fontFamily: 'NotoSans',
    ),
    minLines: minLines,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hintText,
      isDense: true,

      hintStyle: TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 16 * SizeConfig.textRatio,
        fontWeight: FontWeight.w300,
        color: hintColor,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16 * SizeConfig.horizontalBlock,
        vertical: 12 * SizeConfig.verticalBlock,
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      errorStyle: TextStyle(
        fontSize: 12 * SizeConfig.textRatio,
        fontFamily: 'NotoSans',
        color: AppColor.red,
      ),
      filled: true,
      fillColor: AppColor.lightBlue.withOpacity(.08),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
    validator: validator,
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    readOnly: readOnly,
    enabled: enabled,
    autofocus: autofocus,
    onChanged: onChanged,
    onTap: onTap,
    onFieldSubmitted: onFieldSubmitted,
    onSaved: onSaved,
    onEditingComplete: onEditingComplete,
  );
}