import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:internir/screens/applications/applications.dart';
import 'package:internir/screens/profile/admin/admin_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:internir/screens/applications/applications.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_form_field.dart';
import '../../constants/constants.dart';
import '../../providers/Admin/company_provider.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_color.dart';
import '../../utils/size_config.dart';
import '../../providers/Admin/company_auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String routeName = 'dashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompanyProvider>(context, listen: false).fetchJobs();
      Provider.of<CompnayAuthProvider>(context, listen: false)
          .initCompany(); // Initialize company data
    });
  }

  var formKey = GlobalKey<FormState>();
  QuillController descriptionController = QuillController.basic();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController employmentTypeController = TextEditingController();
  TextEditingController selectedCategory = TextEditingController();
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    var companyProvider = Provider.of<CompanyProvider>(context);
    var companyAuthProvider = Provider.of<CompnayAuthProvider>(context);

    String name = companyAuthProvider.company.name.isNotEmpty
        ? companyAuthProvider.company.name
        : "Loading...";
    String? companyImage = companyAuthProvider.company.image;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text(
          'Welcome to dashboard',
          style: TextStyle(
            color: AppColor.mainBlue,
            fontSize: 20 * SizeConfig.textRatio,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSans',
          ),
        ),
        actions: [
          Text(
            '$name\nAdmin',
            style: TextStyle(
              color: AppColor.black,
              fontSize: 15 * SizeConfig.textRatio,
              fontFamily: 'NotoSans',
            ),
          ),
          SizedBox(width: 10 * SizeConfig.horizontalBlock),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminProfileScreen()));
            },
            child: CircleAvatar(
              backgroundImage: (companyImage != null && companyImage.isNotEmpty)
                  ? NetworkImage(
                      companyImage,
                    )
                  : const AssetImage(
                      AppAssets.noProfileImage), // Fallback image
            ),
          ),
          SizedBox(width: 10 * SizeConfig.horizontalBlock),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16 * SizeConfig.horizontalBlock),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Internships',
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 22 * SizeConfig.textRatio,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSans',
                ),
              ),
              SizedBox(height: 20 * SizeConfig.verticalBlock),
              ElevatedButton(
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
                                    text: "Post Job",
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        var companyProvider =
                                            Provider.of<CompanyProvider>(
                                                context,
                                                listen: false);

                                        companyProvider.addJob(
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
                                          category:
                                              selectedCategory.text.isEmpty
                                                  ? null
                                                  : selectedCategory.text,
                                          employmentType:
                                              employmentTypeController
                                                      .text.isNotEmpty
                                                  ? employmentTypeController
                                                      .text
                                                  : null,
                                          enabled: enabled,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainBlue,
                ),
                child: const Text(
                  'Add New Internship',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20 * SizeConfig.verticalBlock),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      border: TableBorder.all(),
                      horizontalMargin: 5 * SizeConfig.horizontalBlock,
                      headingRowColor:
                          MaterialStateProperty.all(AppColor.mainBlue),
                      columnSpacing: 12 * SizeConfig.textRatio,
                      columns: [
                        DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'Internship title',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.white,
                                  fontSize: 16 * SizeConfig.textRatio,
                                  fontFamily: 'NotoSans'),
                            )),
                        DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'Location',
                              style: TextStyle(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16 * SizeConfig.textRatio,
                                  fontFamily: 'NotoSans'),
                            )),
                        DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'N applicants',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.white,
                                  fontSize: 16 * SizeConfig.textRatio,
                                  fontFamily: 'NotoSans'),
                            )),
                        DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text(
                              'Actions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.white,
                                  fontSize: 16 * SizeConfig.textRatio,
                                  fontFamily: 'NotoSans'),
                            )),
                      ],
                      rows: companyProvider.jobs.map((job) {
                        return DataRow(cells: [
                          DataCell(Text(
                            job.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14 * SizeConfig.textRatio,
                                fontFamily: 'NotoSans'),
                          )),
                          DataCell(Text(
                            job.location,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14 * SizeConfig.textRatio,
                                fontFamily: 'NotoSans'),
                          )),
                          DataCell(Text(
                            job.numberOfApplicants.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14 * SizeConfig.textRatio,
                                fontFamily: 'NotoSans'),
                          )),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                print(job);
                                companyProvider.selectedJob = job;
                                print(companyProvider.selectedJob);
                                Navigator.pushNamed(
                                    context, Applications.routeName);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.mainGreen,
                              ),
                              child: const Text(
                                'View Internship',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              if (companyProvider.loading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
