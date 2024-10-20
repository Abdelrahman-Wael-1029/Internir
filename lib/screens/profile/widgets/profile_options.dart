import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';

class ProfileOptions extends StatelessWidget {
  const ProfileOptions({super.key, required this.icon,
    this.iconColor, this.textColor,
    required this.label, this.iconTrail,
    required this.onTap});

  final IconData icon;
  final Color? iconColor;
  final Color? textColor;
  final String label;
  final IconData? iconTrail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,
          size: 30,
          color: iconColor != null ?  AppColor.red : AppColor.mainBlue
      ),
      title: Text(label,
          style: TextStyle(
              fontSize: 20,
              color: textColor ?? AppColor.black)),
      trailing: iconTrail != null ? Icon(iconTrail,
          size: 25,
          color:AppColor.mainBlue) : null,

      onTap: onTap
    );
  }
}
