import 'package:flutter/material.dart';
import 'package:internir/components/job_card.dart';
import 'package:internir/providers/category_provider.dart';
import 'package:internir/utils/size_config.dart';
import 'package:provider/provider.dart'; // Ensure you are using the provider package

class OneCategory extends StatefulWidget {
  final String categoryName; // Category name passed from the previous screen

  const OneCategory({super.key, required this.categoryName});

  static const String routeName = 'oneCategory';

  @override
  State<OneCategory> createState() => _OneCategoryState();
}

class _OneCategoryState extends State<OneCategory> {
  @override
  void initState() {
    super.initState();

    _fetchJobsForCategory(); // Fetch jobs for the selected category
  }

  Future<void> _fetchJobsForCategory() async {
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      // jobsProvider.category = widget.categoryName; // Set the category name
      await categoryProvider.fetchJobs(); // Fetch jobs based on the category
    });
  }

  @override
  Widget build(BuildContext context) {
    var categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.keyboard_backspace_sharp),
          iconSize: 40,
        ),
      ),
      body: (categoryProvider.loading)
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  height: 16 * SizeConfig.verticalBlock,
                ),
                itemCount: categoryProvider.jobsByCategory.length,
                itemBuilder: (context, index) {
                  return jobCard(
                      categoryProvider.jobsByCategory[index], context,
                      isApplied: true); // Display the job card
                },
              ),
            ),
    );
  }
}
