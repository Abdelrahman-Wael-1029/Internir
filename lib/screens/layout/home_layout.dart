import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internir/providers/index_provider.dart';
import 'package:internir/screens/home/home_screen.dart';
import 'package:internir/screens/profile/profile_screen.dart';
import 'package:internir/screens/saved/saved_internships.dart';
import 'package:internir/utils/app_assets.dart';
import 'package:internir/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:internir/components/custom_button.dart';
import 'package:internir/components/custom_text_form_field.dart';
import 'package:internir/constants/constants.dart';
import 'package:internir/providers/Admin/company_provider.dart';
import 'package:internir/utils/size_config.dart';
import 'package:internir/utils/utils.dart';
import 'package:internir/providers/index_provider.dart';
import '../apply_list/applied_list.dart';
import '../home/home_screen.dart';
import '../saved/saved_internships.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:internir/models/job_model.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  static const routeName = '/home-layout';

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}
List<JobModel> savedJobs = [];
class _HomeLayoutState extends State<HomeLayout> {
  var pages = [
    const HomeScreen(),
    const ApplyListScreen(),
    const SavedInternships(),
    const ProfilePage(),
  ];

  var formKey = GlobalKey<FormState>();
  QuillController descriptionController = QuillController.basic();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController employmentTypeController = TextEditingController();
  TextEditingController selectedCategory = TextEditingController();
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    var indexProvider = Provider.of<IndexProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(builder: (context, setState) {
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
                              for (var i = 0; i < listCategories.length; ++i)
                                DropdownMenuItem(
                                  child: Text(listCategories[i]),
                                  value: listCategories[i],
                                ),
                            ],
                            onChanged: (value) {
                              selectedCategory.text = value.toString();
                            },
                            // initial value
                            value: selectedCategory.text = listCategories[0],
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
                              fillColor: AppColor.lightBlue.withOpacity(.08),
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
                              horizontal: 16 * SizeConfig.horizontalBlock,
                              vertical: 12 * SizeConfig.verticalBlock,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.lightBlue.withOpacity(.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: QuillEditor.basic(
                              controller: descriptionController,
                              configurations: const QuillEditorConfigurations(
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
                              horizontal: 32 * SizeConfig.horizontalBlock,
                            ),
                            text: "Post Job",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                var companyProvider =
                                    Provider.of<CompanyProvider>(context,
                                        listen: false);

                                companyProvider.addJob(
                                  title: titleController.text,
                                  description:
                                      encodeQuillContent(descriptionController),
                                  location: locationController.text,
                                  salary: salaryController.text.isNotEmpty
                                      ? double.parse(
                                          salaryController.text,
                                        )
                                      : null,
                                  category: selectedCategory.text,
                                  employmentType:
                                      employmentTypeController.text.isNotEmpty
                                          ? employmentTypeController.text
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
        backgroundColor: AppColor.mainGreen,
        child: const Icon(Icons.add),
      ),
      body: pages[indexProvider.index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: indexProvider.index,
        onTap: (index) {
          indexProvider.setIndex(index);
        },
        backgroundColor: AppColor.background,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppAssets.homeIcon),
            label: "Home",
            activeIcon: SvgPicture.asset(AppAssets.homeOpenIcon),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.applyListImage),
            label: "Apply List",
            activeIcon: Image.asset(AppAssets.applyListOpenImage),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.savedImage),
            label: "Saved",
            activeIcon: Image.asset(AppAssets.savedOpenImage),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(AppAssets.profileImage),
            label: "Profile",
            activeIcon: Image.asset(AppAssets.profileOpenImage),
          ),
        ],
      ),
    );
  }
}
