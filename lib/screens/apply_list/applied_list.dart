import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/job_card.dart';
import '../../providers/jobs_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/size_config.dart';

class ApplyListScreen extends StatefulWidget {
  const ApplyListScreen({super.key});

  static const String routeName = 'appliedList';

  @override
  State<ApplyListScreen> createState() => _ApplyListScreenState();
}

class _ApplyListScreenState extends State<ApplyListScreen> {
  final List<String> _appliedJobs = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadAppliedJobs();
    });
  }

  Future<void> _loadAppliedJobs() async {
    if (user != null) {
      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(user!.uid).get();

      if (userSnapshot.exists) {
        List<String> appliedJobs =
        List<String>.from(userSnapshot['appliedJobs'] ?? []);
        setState(() {
          _appliedJobs.addAll(appliedJobs);
        });
      }
    }
  }

  bool isJobApplied(String jobId) {
    return _appliedJobs.contains(jobId);
  }

  @override
  Widget build(BuildContext context) {
    final jobsProvider = context.watch<JobsProvider>();

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
                    'My Applied Internships',
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
                child: jobsProvider.loading
                    ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.mainBlue),
                  ),
                )
                    : _appliedJobs.isEmpty
                    ? Center(
                  child: Text(
                    "No applied internships.",
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 16 * SizeConfig.textRatio,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: jobsProvider.jobs.length,
                  itemBuilder: (context, index) {
                    final jobId = jobsProvider.jobs[index].id;

                    if (isJobApplied(jobId)) {
                      return Column(
                        children: [
                          SizedBox(
                              height:
                              16 * SizeConfig.verticalBlock),
                          jobCard(jobsProvider.jobs[index],
                              context,
                              isApplied: true),
                          SizedBox(
                              height:
                              16 * SizeConfig.verticalBlock),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
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
