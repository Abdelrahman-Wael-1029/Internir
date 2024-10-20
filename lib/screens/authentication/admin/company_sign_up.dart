import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internir/components/custom_button.dart';
import 'package:internir/components/custom_text_form_field.dart';
import 'package:internir/models/company_model.dart';
import 'package:internir/providers/Admin/company_auth_provider.dart';
import 'package:internir/screens/layout/home_layout.dart';
import 'package:internir/utils/app_assets.dart';
import 'package:internir/utils/app_color.dart';
import 'package:internir/utils/size_config.dart';
import 'package:provider/provider.dart';

class CompanySignUp extends StatefulWidget {
  static const String routeName = '/home';
  const CompanySignUp({super.key});

  @override
  State<CompanySignUp> createState() => _CompanySignUp();
}

class _CompanySignUp extends State<CompanySignUp> {
  final formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    final CompnayAuthProvider compnayAuthProvider =
        context.watch<CompnayAuthProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (compnayAuthProvider.isLoading)
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
                            backgroundImage: (!compnayAuthProvider
                                    .isNetworkImage())
                                ? MemoryImage(compnayAuthProvider.localImage!)
                                : (compnayAuthProvider.company.image == null)
                                    ? AssetImage(AppAssets.noProfileImage
                                        .replaceAll('assets/', ''))
                                    : NetworkImage(
                                        compnayAuthProvider.company.image!),
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
                                compnayAuthProvider.changeCompany(
                                  image: imageFile,
                                  newCompany:
                                      compnayAuthProvider.company.copyWith(
                                    name: compnayAuthProvider.company.name,
                                    email: compnayAuthProvider.company.email,
                                    password:
                                        compnayAuthProvider.company.password,
                                    phone: compnayAuthProvider.company.phone,
                                    address:
                                        compnayAuthProvider.company.address,
                                    description:
                                        compnayAuthProvider.company.description,
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
                          // regix for email validation\
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
                        obscureText: !compnayAuthProvider.isPasswordVisible,
                        suffixIcon: compnayAuthProvider.isPasswordVisible
                            ? IconButton(
                                onPressed: () {
                                  compnayAuthProvider
                                      .togglePasswordVisibility();
                                },
                                icon: const Icon(Icons.remove_red_eye),
                              )
                            : IconButton(
                                onPressed: () {
                                  compnayAuthProvider
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
                            !compnayAuthProvider.isConfirmPasswordVisible,
                        suffixIcon: compnayAuthProvider.isConfirmPasswordVisible
                            ? IconButton(
                                onPressed: () {
                                  compnayAuthProvider
                                      .toggleConfirmPasswordVisibility();
                                },
                                icon: const Icon(Icons.remove_red_eye),
                              )
                            : IconButton(
                                onPressed: () {
                                  compnayAuthProvider
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
                            //regix for phone number
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
                            bool res = await compnayAuthProvider.signUp(
                              context,
                              compnayAuthProvider.company.copyWith(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                address: addressController.text,
                                phone: phoneController.text,
                                description: descriptionController.text,
                              ),
                            );

                            if (res) {
                              Navigator.pushNamed(
                                context,
                                HomeLayout.routeName,
                              );
                            }
                          }
                        },
                        text: 'Sign Up',
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
