import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:internir/providers/jobs_provider.dart';
import 'package:internir/utils/app_color.dart';
import 'package:internir/utils/size_config.dart';
import 'package:internir/components/job_card.dart';

class ApplyListScreen extends StatefulWidget {
  const ApplyListScreen({super.key});

  static const String routeName = 'appliedList';

  @override
  State<ApplyListScreen> createState() => _ApplyListScreenState();
}

class _ApplyListScreenState extends State<ApplyListScreen> {
  @override
  Widget build(BuildContext context) {
    final jobsProvider = context.watch<JobsProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Applied Internships',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: (jobsProvider.loading)
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16 * SizeConfig.verticalBlock,
                  ),
                  child: const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColor.mainBlue),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: jobsProvider.jobs.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 16 * SizeConfig.verticalBlock,
                        ),
                        jobCard(jobsProvider.jobs[index], context,
                            isApplied: true),
                        SizedBox(
                          height: 16 * SizeConfig.verticalBlock,
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
