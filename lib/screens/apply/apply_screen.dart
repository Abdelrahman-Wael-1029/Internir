import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:internir/components/custom_button.dart';
import 'package:internir/models/job_model.dart';
import 'package:internir/screens/apply/apply_to_job.dart';
import 'package:internir/utils/app_color.dart';
import 'package:internir/utils/size_config.dart';
import 'package:internir/utils/utils.dart';
import 'package:internir/providers/saved_jobs_provider.dart';
import 'package:provider/provider.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen({super.key, required this.job});

  final JobModel job;
  static const String routeName = 'applyScreen';

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  //bool isJobSaved = false;
  QuillController descriptionController = QuillController.basic();

  // void saveJob() {
  //   setState(() {
  //     isJobSaved = !isJobSaved;
  //   });
  // }

  @override
  void initState() {
    super.initState();

    descriptionController = QuillController(
      readOnly: true,
      document: decodeQuillContent(widget.job.description),
      configurations: const QuillControllerConfigurations(),
      selection: const TextSelection.collapsed(offset: 0),
    );
    descriptionController.skipRequestKeyboard = true;
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
                      child: const Image(
                        image: NetworkImage(
                          'https://dummyimage.com/300x200/000/fff',
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
                      'Number of applys: ${widget.job.numberOfApplicants}',
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
                    controller: descriptionController,
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
                jobSaveProvider.toggleSaveJob(widget.job.id);  // Toggle job save state
              },
              icon: jobSaveProvider.isJobSaved(widget.job.id)
                  ? const Icon(Icons.bookmark, color: Colors.blue)
                  : const Icon(Icons.bookmark_border, color: Colors.grey),
            ),
            Expanded(
              child: CustomButton(
                text: 'Apply',
                onPressed: () {
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