import 'package:flutter/material.dart';
import '../authentication/admin/company_sign_up.dart';
import '../authentication/login_screen.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_color.dart';
import '../../utils/size_config.dart';
import 'package:provider/provider.dart';
import '../../providers/onboarding_provider.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});
  static const routeName = '/onboarding';

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = context.watch<OnboardingProvider>();
    final PageController pageController = PageController(
      initialPage: onboardingProvider.currentPage,
    );

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              onboardingProvider.setPage(index);
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

              // Second onboarding page (with buttons)
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

                  // The buttons are here, for navigation to different parts of the app
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          onboardingProvider.setType(0);
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
                          onboardingProvider.setType(1);
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
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
                if (onboardingProvider.currentPage == 1)
                  TextButton(
                    onPressed: () {
                      onboardingProvider
                          .setPage(onboardingProvider.currentPage - 1);
                      pageController.previousPage(
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
                      (index) =>
                          buildDot(index, onboardingProvider.currentPage),
                    ),
                  ),
                ),
                if (onboardingProvider.currentPage == 0)
                  TextButton(
                    onPressed: () {
                      onboardingProvider
                          .setPage(onboardingProvider.currentPage + 1);
                      pageController.nextPage(
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
