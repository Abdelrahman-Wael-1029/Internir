import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:internir/components/custom_button.dart';
import 'package:internir/components/custom_text_form_field.dart';
import 'package:internir/constants/constants.dart';
import 'package:internir/models/job_model.dart';
import 'package:internir/providers/Admin/company_provider.dart';
import 'package:internir/components/pdf_viewer.dart';
import 'package:internir/utils/app_color.dart';
import 'package:internir/utils/size_config.dart';
import 'package:internir/utils/utils.dart';
import 'package:provider/provider.dart';

class Applications extends StatefulWidget {
  @override
  State<Applications> createState() => _ApplicationsState();

  static const String routeName = '/applications';

  const Applications({super.key});
}

class _ApplicationsState extends State<Applications> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var companyProvider =
          Provider.of<CompanyProvider>(context, listen: false);
      companyProvider.fetchApplications();
      print(companyProvider.selectedJob!.title);
      titleController.text = companyProvider.selectedJob!.title;
      selectedCategory.text = companyProvider.selectedJob!.category ?? '';
      locationController.text = companyProvider.selectedJob!.location;
      salaryController.text = (companyProvider.selectedJob!.salary != null)
          ? companyProvider.selectedJob!.salary.toString()
          : '';
      employmentTypeController.text =
          companyProvider.selectedJob!.jobType ?? '';
      descriptionController = QuillController(
        document: decodeQuillContent(companyProvider.selectedJob!.description),
        // readOnly: true,
        selection: const TextSelection.collapsed(offset: 0),
      );
    });
    super.initState();
  }

  QuillController descriptionController = QuillController.basic();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController employmentTypeController = TextEditingController();
  TextEditingController selectedCategory = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    var companyProvider = Provider.of<CompanyProvider>(context);
    return Scaffold(
      appBar: AppBar(surfaceTintColor: Colors.transparent, backgroundColor: AppColor.background,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16 * SizeConfig.horizontalBlock,
            vertical: 20 * SizeConfig.verticalBlock,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  companyProvider.selectedJob!.title,
                  style: TextStyle(
                    fontSize: 24 * SizeConfig.textRatio,
                    fontFamily: 'NotoSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Number of applies: ${companyProvider.selectedJob!.numberOfApplicants}',
                  style: TextStyle(
                    fontSize: 14 * SizeConfig.textRatio,
                    fontFamily: 'NotoSans',
                    color: Colors.grey,
                  ),
                ),
              ),
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
              if (companyProvider.selectedJob!.jobType != null)
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
                        companyProvider.selectedJob!.jobType!,
                        style: TextStyle(
                          fontSize: 14 * SizeConfig.textRatio,
                          fontFamily: 'NotoSans',
                        ),
                      ),
                    ),
                    SizedBox(height: 16 * SizeConfig.verticalBlock),
                  ],
                ),
              if (companyProvider.selectedJob!.salary != null)
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
                        '${companyProvider.selectedJob!.salary!}\$',
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
                  companyProvider.selectedJob!.location,
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
                  '${companyProvider.selectedJob!.createdAt.month} / ${companyProvider.selectedJob!.createdAt.year}',
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
                  companyProvider.selectedJob!.category ??
                      'No category specified',
                  style: TextStyle(
                    fontSize: 14 * SizeConfig.textRatio,
                    fontFamily: 'NotoSans',
                  ),
                ),
              ),
              _buildSectionTitle('Applications'),
              SizedBox(height: 16 * SizeConfig.verticalBlock),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    horizontalMargin: 5 * SizeConfig.horizontalBlock,
                    headingRowColor:
                        MaterialStateProperty.all(AppColor.mainBlue),
                    columnSpacing: 12 * SizeConfig.textRatio,
                    border: TableBorder.all(
                        color: AppColor.black,
                        borderRadius: BorderRadius.circular(8),
                        width: 1,
                        style: BorderStyle.solid),
                    columns: [
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          'Applied Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: 'NotoSans',
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          'Applied Nmail',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: 'NotoSans',
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          'Applied Phone',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: 'NotoSans',
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          'Applied Date',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: 'NotoSans',
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          'Atatus',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: 'NotoSans',
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          'Resume',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: 'NotoSans',
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          'Actions',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.white,
                            fontFamily: 'NotoSans',
                            fontSize: 16 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: companyProvider.applications.map((application) {
                      return DataRow(cells: [
                        DataCell(
                          Text(
                            application.username,
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 14 * SizeConfig.textRatio,
                            ),
                          ),
                        ),
                        DataCell(Text(
                          application.email,
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 14 * SizeConfig.textRatio,
                          ),
                        )),
                        DataCell(Text(
                          application.phone,
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 14 * SizeConfig.textRatio,
                          ),
                        )),
                        DataCell(Text(
                          "${application.appliedAt.year} / ${application.appliedAt.month} / ${application.appliedAt.day}",
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 14 * SizeConfig.textRatio,
                          ),
                        )),
                        DataCell(
                          Text(
                            application.status,
                            style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 14 * SizeConfig.textRatio,
                            ),
                          ),
                        ),
                        DataCell(
                          CustomButton(
                            fontSize: 14 * SizeConfig.textRatio,
                              text: 'View Resume',
                              textColor: AppColor.lightBlue,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  PdfViewer.routeName,
                                  arguments: application.resume,
                                );
                              }),
                        ),
                        DataCell(
                          Row(
                            children: [
                              CustomButton(
                                  text: 'Approve',
                                  fontSize: 14 * SizeConfig.textRatio,
                                  textColor: AppColor.mainGreen,
                                  onPressed: () {
                                    companyProvider.updateStatus(
                                        application, 'approved');
                                  }),
                              SizedBox(
                                width: 12 * SizeConfig.horizontalBlock,
                              ),
                              CustomButton(
                                  text: 'Reject',
                            fontSize: 14 * SizeConfig.textRatio,
                                  textColor: AppColor.red,
                                  onPressed: () {
                                    companyProvider.updateStatus(
                                        application, 'rejected');
                                  }),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Edit Job',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        title: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Add new jobs',
                            style: TextStyle(
                              color: AppColor.mainBlue,
                              fontFamily: 'NotoSans',
                              fontSize: 20 * SizeConfig.textRatio,
                            ),
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: SizedBox(
                            width: SizeConfig.screenWidth * .8,
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Title",
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 16 * SizeConfig.textRatio,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8 * SizeConfig.verticalBlock,
                                  ),
                                  customTextFormField(
                                    controller: titleController,
                                    validator: (p0) {
                                      if (p0!.isEmpty) {
                                        return 'Please enter title';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20 * SizeConfig.verticalBlock,
                                  ),
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 16 * SizeConfig.textRatio,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8 * SizeConfig.verticalBlock,
                                  ),

                                  DropdownButtonFormField(
                                    items: [
                                      for (var i = 0;
                                          i < listCategories.length;
                                          ++i)
                                        DropdownMenuItem(
                                          value: listCategories[i],
                                          child: Text(listCategories[i]),
                                        ),
                                    ],
                                    onChanged: (value) {
                                      selectedCategory.text = value.toString();
                                    },
                                    // initial value
                                    value: selectedCategory.text,
                                    style: TextStyle(
                                      fontSize: 16 * SizeConfig.textRatio,
                                      fontFamily: 'NotoSans',
                                      color: AppColor.black,
                                    ),
                                    isExpanded: true,
                                    alignment: Alignment.center,
                                    borderRadius: BorderRadius.circular(8),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select category';
                                      }
                                      if (listCategories.contains(value)) {
                                        return null;
                                      }
                                      return 'Please select valid category';
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          AppColor.lightBlue.withOpacity(.08),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  /*
                            DropdownMenu<String>(
                              dropdownMenuEntries: listCategories
                                  .map((e) => DropdownMenuEntry(
                                        label: e,
                                        value: e,
                                      ))
                                  .toList(),
                              enableFilter: true,
                              menuStyle: const MenuStyle(
                                alignment: Alignment.bottomLeft,
                              ),
                              controller: selectedCategory,
                              requestFocusOnTap: true,
                              onSelected: (country) {},
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'NotoSans',
                                color: AppColor.black,
                              ),
                              initialSelection: listCategories[0],
                              enabled: false,
                            ),
                  */
                                  SizedBox(
                                    height: 20 * SizeConfig.verticalBlock,
                                  ),
                                  Text(
                                    "Location",
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 16 * SizeConfig.textRatio,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8 * SizeConfig.verticalBlock,
                                  ),
                                  customTextFormField(
                                    controller: locationController,
                                    validator: (p0) {
                                      if (p0!.isEmpty) {
                                        return 'Please enter location';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20 * SizeConfig.verticalBlock,
                                  ),
                                  Text(
                                    "Salary",
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 16 * SizeConfig.textRatio,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8 * SizeConfig.verticalBlock,
                                  ),
                                  customTextFormField(
                                    controller: salaryController,
                                    validator: (p0) {
                                      try {
                                        if (p0 != null && p0.isNotEmpty) {
                                          double.parse(p0);
                                        }
                                        return null;
                                      } catch (e) {
                                        return 'Please enter valid number for salary';
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 20 * SizeConfig.verticalBlock,
                                  ),
                                  Text(
                                    "Employment Type",
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 16 * SizeConfig.textRatio,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8 * SizeConfig.verticalBlock,
                                  ),
                                  customTextFormField(
                                    controller: employmentTypeController,
                                  ),
                                  // select dropdown
                                  SizedBox(
                                    height: 20 * SizeConfig.verticalBlock,
                                  ),

                                  Text(
                                    "Description",
                                    style: TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 16 * SizeConfig.textRatio,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8 * SizeConfig.verticalBlock,
                                  ),
                                  // text editor
                                  QuillSimpleToolbar(
                                    controller: descriptionController,
                                    configurations:
                                        const QuillSimpleToolbarConfigurations(
                                      showClipboardCopy: false,
                                      showClipboardCut: false,
                                      showClipboardPaste: false,
                                    ),
                                  ),
                                  Container(
                                    height: 250 * SizeConfig.verticalBlock,
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          16 * SizeConfig.horizontalBlock,
                                      vertical: 12 * SizeConfig.verticalBlock,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColor.lightBlue.withOpacity(.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: QuillEditor.basic(
                                      controller: descriptionController,
                                      configurations:
                                          const QuillEditorConfigurations(
                                        minHeight: double.infinity,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20 * SizeConfig.verticalBlock,
                                  ),
                                  // checkbox for enabled
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: enabled,
                                        onChanged: (value) {
                                          setState(() {
                                            enabled = value!;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: 8 * SizeConfig.horizontalBlock,
                                      ),
                                      Text(
                                        "Enabled",
                                        style: TextStyle(
                                          fontFamily: 'NotoSans',
                                          fontSize: 16 * SizeConfig.textRatio,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 32 * SizeConfig.verticalBlock,
                                  ),
                                  CustomButton(
                                    width: double.infinity,
                                    fontSize: 16 * SizeConfig.textRatio,
                                    backgroundColor: AppColor.mainGreen,
                                    textColor: AppColor.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8 * SizeConfig.verticalBlock,
                                      horizontal:
                                          32 * SizeConfig.horizontalBlock,
                                    ),
                                    text: "Update Job",
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        var companyProvider =
                                            Provider.of<CompanyProvider>(
                                                context,
                                                listen: false);

                                        companyProvider.updateJob(
                                          job: companyProvider.selectedJob!
                                              .copyWith(
                                            title: titleController.text,
                                            description: encodeQuillContent(
                                                descriptionController),
                                            location: locationController.text,
                                            salary:
                                                salaryController.text.isNotEmpty
                                                    ? double.parse(
                                                        salaryController.text,
                                                      )
                                                    : null,
                                            category: selectedCategory.text,
                                            jobType: employmentTypeController
                                                    .text.isNotEmpty
                                                ? employmentTypeController.text
                                                : null,
                                            enabled: enabled,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
                backgroundColor: AppColor.mainGreen,
                textColor: AppColor.white,
              ),
            ),
            SizedBox(width: 8 * SizeConfig.horizontalBlock),
            Expanded(
              child: CustomButton(
                text: 'Delete Job',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Confirmation'),
                          content: const Text(
                              'Are you sure you want to delete this job?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                companyProvider
                                    .deleteJob(companyProvider.selectedJob!.id);
                                Navigator.pop(context);
                              },
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      });
                },
                backgroundColor: AppColor.red,
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
