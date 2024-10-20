import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:internir/models/company_model.dart';
import 'package:internir/services/fire_database.dart';
import 'package:internir/services/fire_storage.dart';

class CompnayAuthProvider with ChangeNotifier {
  CompanyModel company = CompanyModel(
    id: '',
    name: '',
    email: '',
    password: '',
    phone: '',
    address: '',
    description: '',
    jobs: [],
  );

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  bool isLocalImage = false;

  Uint8List? localImage;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

// for edit user profile
  Future<void> initCompany() async {
    try {
      // give name from firestore
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var data = await FireDatabase.getDocument('company', uid);
      company = CompanyModel(
        id: uid,
        name: data['name'],
        email: data['email'],
        password: data['password'],
        phone: data['phone'],
        address: data['address'],
        description: data['description'],
        image: data['image'],
        jobs: data['jobs'],
      );
      isLocalImage = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void changeCompany({
    required CompanyModel newCompany,
    Uint8List? image,
  }) {
    if (image != null) {
      localImage = image;
      isLocalImage = true;
    }
    company = company!.copyWith(
      image: isLocalImage ? null : newCompany.image,
      jobs: newCompany.jobs,
      id: newCompany.id,
      name: newCompany.name,
      email: newCompany.email,
      password: newCompany.password,
      phone: newCompany.phone,
      address: newCompany.address,
      description: newCompany.description,
    );

    notifyListeners();
  }

  Future<void> updateCompany(context, CompanyModel company) async {
    isLoading = true;
    notifyListeners();
    try {
      String? urlImage;
      if (isLocalImage && localImage != null) {
        urlImage = await FireStorage.uploadFile(
          path: 'company/${company.id}',
          fileName: 'profile.png',
          file: localImage!,
        );
        isLocalImage = false;
      }
      await FireDatabase.updateData(
        'company',
        company.id,
        company.toJson(),
      );
      company = company.copyWith(image: urlImage);

      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> signUp(context, CompanyModel company) async {
    isLoading = true;
    notifyListeners();
    try {
      // create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: company.email,
        password: company.password,
      );

      // add user to firestore
      String uid = FirebaseAuth.instance.currentUser!.uid;

      String? urlImage;
      if (isLocalImage && localImage != null) {
        urlImage = await FireStorage.uploadFile(
          path: 'company/${company.id}',
          fileName: 'profile.png',
          file: localImage!,
        );
        isLocalImage = false;
      }
      company = company.copyWith(id: uid, jobs: [], image: urlImage);

      await FireDatabase.updateData(
        'company',
        company.id,
        company.toJson(),
      );
      return true;
    } catch (error) {
      debugPrint(error.toString());
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  bool isNetworkImage() {
    if (!isLocalImage) {
      return true;
    }
    return false;
  }

  void clear() {
    notifyListeners();
  }
}
