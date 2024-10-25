import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';
import '../screens/category/one_category.dart';
import '../utils/app_color.dart';
import '../utils/size_config.dart';


Widget categoryCard({
  required String category,
  required BuildContext context,
  double? width,
}) {
  return InkWell(
    onTap: () {
      var categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      categoryProvider.setCategory(category);
      Navigator.pushNamed(
        context,
        OneCategory.routeName,
        arguments: category,
      );
    },
    child: Container(
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: 12 * SizeConfig.horizontalBlock,
        vertical: 8 * SizeConfig.verticalBlock,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.mainBlue,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          category,
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 16 * SizeConfig.textRatio,
            color: AppColor.mainBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
