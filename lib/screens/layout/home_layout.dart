import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internir/screens/profile/user_profile/profile_screen.dart';
import '../../providers/index_provider.dart';
import '../home/home_screen.dart';
import '../saved/saved_internships.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_color.dart';
import 'package:provider/provider.dart';
import '../apply_list/applied_list.dart';
import '../../models/job_model.dart';

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
    const UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    var indexProvider = Provider.of<IndexProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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