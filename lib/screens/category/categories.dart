import 'package:flutter/material.dart';
import 'package:internir/components/category_card.dart';
import 'package:internir/components/custom_search.dart';
import 'package:internir/providers/category_provider.dart';
import 'package:internir/utils/app_color.dart';
import 'package:internir/utils/size_config.dart';
import 'package:provider/provider.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  static const String routeName = '/categories';

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomSearch(
                onChanged: (category) => categoryProvider.searchCategory(category),
                color: AppColor.grey2,
                hintText: "Search Categories",
              ),
              SizedBox(
                height: 32 * SizeConfig.verticalBlock,
              ),
              
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => categoryCard(
                  category: categoryProvider.allCategory[index],
                  context: context,
                ),
                separatorBuilder: (context, index) => SizedBox(
                  height: 20 * SizeConfig.verticalBlock,
                ),
                itemCount: categoryProvider.allCategory.length,
              )
            
            ],
          ),
        ),
      ),
    );
  }
}
