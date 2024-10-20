import 'package:flutter/material.dart';
import '../../components/saved_job_card.dart';
import '../../models/job_model.dart';
import '../../providers/jobs_provider.dart';
import '../../providers/saved_jobs_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/size_config.dart';
import 'package:provider/provider.dart';

class SavedInternships extends StatefulWidget {
  const SavedInternships({super.key});

  @override
  State<SavedInternships> createState() => _SavedInternshipsState();
}

class _SavedInternshipsState extends State<SavedInternships> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final jobsProvider = context.watch<JobsProvider>();
    final savedJobsProvider = context.watch<JobSaveProvider>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.background,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16 * SizeConfig.horizontalBlock,
            vertical: 20 * SizeConfig.verticalBlock,
          ),
          child: Column(
            children: [
              SizedBox(height: 20 * SizeConfig.verticalBlock),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'My Saved Internships',
                    style: TextStyle(
                      color: AppColor.mainBlue,
                      fontSize: 25 * SizeConfig.textRatio,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSans',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16 * SizeConfig.verticalBlock),
              Expanded(
                child: savedJobsProvider.savedJobs.isEmpty
                    ? Center(
                  child: Text(
                    "No saved internships.",
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 16 * SizeConfig.textRatio,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: savedJobsProvider.savedJobs.length,
                  itemBuilder: (context, index) {
                    final jobId = savedJobsProvider.savedJobs[index];
                    final job = jobsProvider.jobs.firstWhere(
                          (job) => job.id == jobId,
                      orElse: () => JobModel(
                        id: '',
                        title: '',
                        company: '',
                        description: '',
                        salary: null,
                        location: '',
                        createdAt: DateTime.now(),
                        category: null,
                        numberOfApplicants: 0,
                        enabled: false,
                      ),
                    );
                    return Column(
                      children: [
                        SizedBox(height: 16 * SizeConfig.verticalBlock),
                        savedJobCard(job, context),
                        SizedBox(height: 16 * SizeConfig.verticalBlock),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
