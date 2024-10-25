import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_screen.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../providers/Admin/company_auth_provider.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_color.dart';
import '../../../utils/size_config.dart';
import 'package:provider/provider.dart';

class CompanySignUp extends StatefulWidget {
  static const String routeName = '/home';

  const CompanySignUp({super.key});

  @override
  State<CompanySignUp> createState() => _CompanySignUp();
}

class _CompanySignUp extends State<CompanySignUp> {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var addressController = TextEditingController();
  var phoneController = TextEditingController();
  var descriptionController = TextEditingController();

  Future<void> _checkVerification() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Your email has been verified successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.routeName,
                        (route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not verified yet!')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final CompnayAuthProvider companyAuthProvider =
        context.watch<CompnayAuthProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (companyAuthProvider.isLoading)
                const LinearProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 100,
                            onBackgroundImageError: (exception, stackTrace) {},
                            backgroundImage: (!companyAuthProvider
                                    .isNetworkImage())
                                ? MemoryImage(companyAuthProvider.localImage!)
                                : (companyAuthProvider.company.image == null)
                                    ? AssetImage(
                                        AppAssets.noProfileImage
                                            .replaceAll('assets/', ''),
                                      )
                                    : NetworkImage(
                                        companyAuthProvider.company.image!,
                                      ),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: IconButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image == null) {
                                  return;
                                }
                                Uint8List imageFile = await image.readAsBytes();
                                companyAuthProvider.changeCompany(
                                  image: imageFile,
                                  newCompany:
                                      companyAuthProvider.company.copyWith(
                                    name: companyAuthProvider.company.name,
                                    email: companyAuthProvider.company.email,
                                    password:
                                        companyAuthProvider.company.password,
                                    phone: companyAuthProvider.company.phone,
                                    address:
                                        companyAuthProvider.company.address,
                                    description:
                                        companyAuthProvider.company.description,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.camera_alt),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32 * SizeConfig.verticalBlock,
                      ),
                      customTextFormField(
                        hintText: 'Name',
                        controller: nameController,
                        hintColor: AppColor.grey1,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 32 * SizeConfig.verticalBlock,
                      ),
                      customTextFormField(
                        controller: emailController,
                        hintText: 'Email',
                        hintColor: AppColor.grey1,
                        prefixIcon: const Icon(Icons.email),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }
                          var reg = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!reg.hasMatch(value)) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 32 * SizeConfig.verticalBlock,
                      ),
                      customTextFormField(
                        controller: passwordController,
                        hintText: 'Password',
                        hintColor: AppColor.grey1,
                        prefixIcon: const Icon(Icons.lock),
                        obscureText: !companyAuthProvider.isPasswordVisible,
                        suffixIcon: companyAuthProvider.isPasswordVisible
                            ? IconButton(
                                onPressed: () {
                                  companyAuthProvider
                                      .togglePasswordVisibility();
                                },
                                icon: const Icon(Icons.remove_red_eye),
                              )
                            : IconButton(
                                onPressed: () {
                                  companyAuthProvider
                                      .togglePasswordVisibility();
                                },
                                icon: const Icon(Icons.visibility_off),
                              ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 32 * SizeConfig.verticalBlock,
                      ),
                      customTextFormField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText:
                            !companyAuthProvider.isConfirmPasswordVisible,
                        suffixIcon: companyAuthProvider.isConfirmPasswordVisible
                            ? IconButton(
                                onPressed: () {
                                  companyAuthProvider
                                      .toggleConfirmPasswordVisibility();
                                },
                                icon: const Icon(Icons.remove_red_eye),
                              )
                            : IconButton(
                                onPressed: () {
                                  companyAuthProvider
                                      .toggleConfirmPasswordVisibility();
                                },
                                icon: const Icon(Icons.visibility_off),
                              ),
                        hintColor: AppColor.grey1,
                        prefixIcon: const Icon(Icons.lock),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Confirm Password is required';
                          }
                          if (value != passwordController.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 32 * SizeConfig.verticalBlock,
                      ),
                      customTextFormField(
                        controller: addressController,
                        hintText: 'Address',
                        hintColor: AppColor.grey1,
                        prefixIcon: const Icon(Icons.location_on),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Address is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 32 * SizeConfig.verticalBlock,
                      ),
                      customTextFormField(
                          controller: phoneController,
                          hintText: 'Phone',
                          hintColor: AppColor.grey1,
                          prefixIcon: const Icon(Icons.phone),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Phone is required';
                            }
                            RegExp reg = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
                            if (!reg.hasMatch(value)) {
                              return 'Invalid phone number';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 32 * SizeConfig.verticalBlock,
                      ),
                      customTextFormField(
                        controller: descriptionController,
                        hintText: 'Description',
                        hintColor: AppColor.grey1,
                        prefixIcon: const Icon(Icons.description),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                        maxLines: 3,
                        minLines: 3,
                      ),
                      SizedBox(
                        height: 32 * SizeConfig.verticalBlock,
                      ),
                      CustomButton(
                        width: double.infinity,
                        textColor: AppColor.white,
                        backgroundColor: AppColor.indigo,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            bool res = await companyAuthProvider.signUp(
                              context,
                              companyAuthProvider.company.copyWith(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                address: addressController.text,
                                phone: phoneController.text,
                                description: descriptionController.text,
                              ),
                            );
                            if (res) {
                              User? user = _auth.currentUser;
                              if (user != null && !user.emailVerified) {
                                await user.sendEmailVerification();
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'A verification email has been sent. Please verify your email.',
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            // Close dialog
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                Future.delayed(const Duration(seconds: 5), () {
                                  _checkVerification();
                                });
                              }
                            }
                          }
                        },
                        text: 'Sign Up',
                      ),
                      SizedBox(
                        height: 16 * SizeConfig.verticalBlock,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            LoginScreen.routeName,
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
