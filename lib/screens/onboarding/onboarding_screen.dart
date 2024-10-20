import 'package:flutter/material.dart';
import 'package:internir/screens/authentication/admin/company_sign_up.dart';
import 'package:internir/utils/app_assets.dart';
import 'package:internir/utils/app_color.dart';
import 'package:internir/utils/size_config.dart';
import 'package:internir/screens/layout/home_layout.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});
  static const routeName = '/onboarding';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              // First onboarding page
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.onboardingImage1,
                    width: 500,
                    height: 350,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Internir',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Get started with our awesome app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),

              // Second onboarding page
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.onboardingImage2,
                    width: 500,
                    height: 350,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Get Started Now',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Create your account and enjoy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, CompanySignUp.routeName);
                        },
                        child: Text(
                          'Employee',
                          style: TextStyle(
                            fontSize: 20 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, HomeLayout.routeName);
                        },
                        child: Text(
                          'Intern Seeker',
                          style: TextStyle(
                            fontSize: 20 * SizeConfig.textRatio,
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Navigation buttons and dots
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "Back" button on the second page
                if (_currentPage == 1)
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 20 * SizeConfig.textRatio,
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainBlue,
                      ),
                    ),
                  ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      2,
                      (index) => buildDot(index, _currentPage),
                    ),
                  ),
                ),

                // "Next" button on the first page
                if (_currentPage == 0)
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20 * SizeConfig.textRatio,
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainBlue,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, int currentPage) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
