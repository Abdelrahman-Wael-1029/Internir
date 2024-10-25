import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

import 'package:internir/components/custom_button.dart';
import 'package:internir/models/job_model.dart';
import 'package:internir/screens/apply/apply_to_job.dart';
import 'package:internir/utils/app_color.dart';
import 'package:internir/utils/size_config.dart';
import 'package:internir/utils/utils.dart';
import 'package:internir/providers/saved_jobs_provider.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({super.key, required this.job});

  final JobModel job;
  static const String routeName = 'applyScreen';

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  QuillController _descriptionController = QuillController.basic();
  String? _companyImage;

  Future<void> fetchCompanyImage() async {
    String companyUid = widget.job.companyID;
    try {
      DocumentSnapshot companyDoc = await FirebaseFirestore.instance
          .collection('company')
          .doc(companyUid)
          .get();

      if (companyDoc.exists) {
        _companyImage = companyDoc.get('image');
      } else {
        print('Company document does not exist');
      }
    } catch (e) {
      print('Error fetching company image: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _descriptionController = QuillController(
      readOnly: true,
      document: decodeQuillContent(widget.job.description),
      configurations: const QuillControllerConfigurations(),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _descriptionController.skipRequestKeyboard = true;

    fetchCompanyImage();
  }

  Future<bool> getAppliedState() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        List<String> appliedJobs = List<String>.from(userSnapshot.get('appliedJobs'));

        return appliedJobs.contains(widget.job.id);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final jobSaveProvider = Provider.of<JobSaveProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColor.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image(
                        image: NetworkImage(
                          _companyImage ??
                              'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                        ),
                        fit: BoxFit.cover,
                        width: 104,
                        height: 104,
                      ),
                    ),
                    SizedBox(height: 16 * SizeConfig.verticalBlock),
                    Text(
                      widget.job.title,
                      style: TextStyle(
                        fontSize: 24 * SizeConfig.textRatio,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.job.company,
                      style: TextStyle(
                        fontSize: 18 * SizeConfig.textRatio,
                        fontFamily: 'NotoSans',
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4 * SizeConfig.verticalBlock),
                    Text(
                      'Number of applies: ${widget.job.numberOfApplicants}',
                      style: TextStyle(
                        fontSize: 14 * SizeConfig.textRatio,
                        fontFamily: 'NotoSans',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24 * SizeConfig.verticalBlock),
              _buildSectionTitle('Job Description:'),
              IntrinsicHeight(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * SizeConfig.horizontalBlock,
                    vertical: 12 * SizeConfig.verticalBlock,
                  ),
                  child: QuillEditor.basic(
                    focusNode: FocusNode(
                      canRequestFocus: false,
                    ),
                    controller: _descriptionController,
                    configurations: const QuillEditorConfigurations(
                      minHeight: double.infinity,
                    ),
                  ),
                ),
              ),
              if (widget.job.jobType != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSectionTitle('Job Type:'),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16 * SizeConfig.horizontalBlock,
                        top: 8 * SizeConfig.verticalBlock,
                        bottom: 12 * SizeConfig.verticalBlock,
                      ),
                      child: Text(
                        widget.job.jobType!,
                        style: TextStyle(
                          fontSize: 14 * SizeConfig.textRatio,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                    ),
                    SizedBox(height: 16 * SizeConfig.verticalBlock),
                  ],
                ),
              if (widget.job.salary != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSectionTitle('Salary'),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16 * SizeConfig.horizontalBlock,
                        top: 8 * SizeConfig.verticalBlock,
                        bottom: 12 * SizeConfig.verticalBlock,
                      ),
                      child: Text(
                        '${widget.job.salary!}\$',
                        style: TextStyle(
                          fontSize: 14 * SizeConfig.textRatio,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                    ),
                    SizedBox(height: 16 * SizeConfig.verticalBlock),
                  ],
                ),
              _buildSectionTitle('Location:'),
              Padding(
                padding: EdgeInsets.only(
                  left: 16 * SizeConfig.horizontalBlock,
                  top: 8 * SizeConfig.verticalBlock,
                  bottom: 12 * SizeConfig.verticalBlock,
                ),
                child: Text(
                  widget.job.location,
                  style: TextStyle(
                    fontSize: 14 * SizeConfig.textRatio,
                    fontFamily: 'NotoSans',
                  ),
                ),
              ),
              _buildSectionTitle('Created At:'),
              Padding(
                padding: EdgeInsets.only(
                  left: 16 * SizeConfig.horizontalBlock,
                  top: 8 * SizeConfig.verticalBlock,
                  bottom: 12 * SizeConfig.verticalBlock,
                ),
                child: Text(
                  '${widget.job.createdAt.month} / ${widget.job.createdAt.year}',
                  style: TextStyle(
                    fontSize: 14 * SizeConfig.textRatio,
                    fontFamily: 'NotoSans',
                  ),
                ),
              ),
              _buildSectionTitle('Category:'),
              Padding(
                padding: EdgeInsets.only(
                  left: 16 * SizeConfig.horizontalBlock,
                  top: 8 * SizeConfig.verticalBlock,
                  bottom: 12 * SizeConfig.verticalBlock,
                ),
                child: Text(
                  widget.job.category ?? 'No category specified',
                  style: TextStyle(
                    fontSize: 14 * SizeConfig.textRatio,
                    fontFamily: 'NotoSans',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                jobSaveProvider.toggleSaveJob(widget.job.id);
              },
              icon: jobSaveProvider.isJobSaved(widget.job.id)
                  ? const Icon(Icons.bookmark, color: Colors.blue)
                  : const Icon(Icons.bookmark_border, color: Colors.grey),
            ),
            Expanded(
              child: CustomButton(
                text: 'Apply',
                onPressed: () async {
                  bool applied = await getAppliedState();

                  if (applied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You have already applied to this job!'),
                      ),
                    );
                    return;
                  }
                  Navigator.of(context).pushNamed(
                    ApplyToJob.routeName,
                    arguments: widget.job,
                  );
                },
                backgroundColor: AppColor.lightBlue,
                textColor: AppColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16 * SizeConfig.textRatio,
        fontFamily: 'NotoSans',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
