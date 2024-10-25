import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internir/providers/Admin/company_provider.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../providers/Admin/company_auth_provider.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_color.dart';
import '../../../utils/size_config.dart';
import 'package:provider/provider.dart';

class AdminEditProfileScreen extends StatefulWidget {
  static const String routeName = '/admin_edit_profile';

  const AdminEditProfileScreen({super.key});

  @override
  State<AdminEditProfileScreen> createState() => _AdminEditProfileScreen();
}

class _AdminEditProfileScreen extends State<AdminEditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var companyAuthProvider =
          Provider.of<CompnayAuthProvider>(context, listen: false);
      companyAuthProvider.initCompany().then((v) {
        nameController.text = companyAuthProvider.company.name;
        emailController.text = companyAuthProvider.company.email;
        passwordController.text = companyAuthProvider.company.password;
        confirmPasswordController.text = companyAuthProvider.company.password;
        addressController.text = companyAuthProvider.company.address;
        phoneController.text = companyAuthProvider.company.phone;
        descriptionController.text = companyAuthProvider.company.description;
      });
    });
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
    final CompnayAuthProvider companyAuthProvider =
        context.watch<CompnayAuthProvider>();
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: (companyAuthProvider.isLoading)
          ? const LinearProgressIndicator()
          : const SizedBox(
              height: 0,
            ),
      body: SingleChildScrollView(
        child: Center(
          child: (companyAuthProvider.company.id.isEmpty)
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                                  onBackgroundImageError:
                                      (exception, stackTrace) {},
                                  backgroundImage: (!companyAuthProvider
                                          .isNetworkImage())
                                      ? MemoryImage(
                                          companyAuthProvider.localImage!)
                                      : (companyAuthProvider.company.image ==
                                              null)
                                          ? AssetImage(
                                              AppAssets.noProfileImage
                                                  .replaceAll('assets/', ''),
                                            )
                                          : NetworkImage(
                                              companyAuthProvider
                                                  .company.image!,
                                            ),
                                ),
                                Positioned(
                                  bottom: -5,
                                  right: -5,
                                  child: IconButton(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final XFile? image =
                                          await picker.pickImage(
                                              source: ImageSource.gallery);
                                      if (image == null) {
                                        return;
                                      }
                                      Uint8List imageFile =
                                          await image.readAsBytes();
                                      companyAuthProvider.changeCompany(
                                        image: imageFile,
                                        newCompany: companyAuthProvider.company
                                            .copyWith(
                                          name:
                                              companyAuthProvider.company.name,
                                          email:
                                              companyAuthProvider.company.email,
                                          password: companyAuthProvider
                                              .company.password,
                                          phone:
                                              companyAuthProvider.company.phone,
                                          address: companyAuthProvider
                                              .company.address,
                                          description: companyAuthProvider
                                              .company.description,
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
                              obscureText:
                                  !companyAuthProvider.isPasswordVisible,
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
                              suffixIcon: companyAuthProvider
                                      .isConfirmPasswordVisible
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
                                  RegExp reg =
                                      RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
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
                                  bool res =
                                      await companyAuthProvider.updateCompany(
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Profile updated successfully!'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Failed to update profile.'),
                                      ),
                                    );
                                  }
                                }
                              },
                              text: 'Update Profile',
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
