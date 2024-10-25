import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internir/models/application_model.dart';
import '../../models/company_model.dart';
import '../../models/job_model.dart';
import '../../services/fire_database.dart';

class CompanyProvider extends ChangeNotifier {
  List<JobModel> jobs = [];
  List<ApplicationModel> applications = [];
  bool loading = false;

  JobModel? selectedJob;

  Future<void> fetchApplications() async {
    try {
      loading = true;
      notifyListeners();
      applications.clear();
      var companyId = FirebaseAuth.instance.currentUser!.uid;

      var allApplications = await FirebaseFirestore.instance
          .collection('company')
          .doc(companyId)
          .collection('jobs')
          .doc(selectedJob!.id)
          .collection('applications')
          .get();

      for (var element in allApplications.docs) {
        applications.add(ApplicationModel.fromJson(element.data()));
      }

      notifyListeners();
    } catch (e) {
      debugPrint('$e fetchApplications');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void initFieldsEdit() {}

  Future<void> fetchJobs() async {
    try {
      loading = true;
      notifyListeners();

      jobs.clear();
      var myJobs = await FirebaseFirestore.instance
          .collection('company')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('jobs')
          .get();

      for (var job in myJobs.docs) {
        jobs.add(JobModel.fromJson(
          await FireDatabase.getDocument('jobs', job.id),
        ));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('$e fetchJobs');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addJob({
    required String title,
    required String description,
    required String location,
    double? salary,
    String? category,
    String? employmentType,
    required bool enabled,
  }) async {
    try {
      loading = true;
      notifyListeners();
      DocumentReference<Map<String, dynamic>>? id = await FireDatabase.addData(
        collection: 'jobs',
        data: {
          'title': title,
          'description': description,
          'location': location,
          'salary': salary,
          'category': category,
          'job type': employmentType,
          'createdAt': Timestamp.fromDate(DateTime.now()),
          'number of applicants': 0,
          'enabled': enabled,
          'companyID': FirebaseAuth.instance.currentUser!.uid
        },
      );

      var companyID = FirebaseAuth.instance.currentUser!.uid;
      // collection company doc:id collection jobs
      FirebaseFirestore.instance
          .collection('company')
          .doc(companyID)
          .collection('jobs')
          .doc(id!.id)
          .set({});

      // fetch company name
      var company = CompanyModel.fromJson(
          await FireDatabase.getDocument('company', companyID));
      await FireDatabase.updateData(
        'jobs',
        id.id,
        {'id': id.id, 'company': company.name},
      );

      fetchJobs();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateJob({
    required JobModel job,
  }) async {
    try {
      loading = true;
      notifyListeners();
      // create At in firebase
      await FireDatabase.updateData(
        'jobs',
        job.id,
        job.toJson().map((key, value) {
          if (key == 'createdAt') {
            return MapEntry(key, Timestamp.fromDate(job.createdAt));
          }
          return MapEntry(key, value);
        }),
      );
      selectedJob = job;
      fetchJobs();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteJob(String id) async {
    try {
      loading = true;
      notifyListeners();
      await FirebaseFirestore.instance
          .collection('company')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('jobs')
          .doc(id)
          .delete();
      await FireDatabase.deleteData('jobs', id);
      fetchJobs();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateStatus(ApplicationModel application, String s) async {
    var last = application.status;
    try {
      application.status = s;
      notifyListeners();
      var companyId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('company')
          .doc(companyId)
          .collection('jobs')
          .doc(selectedJob!.id)
          .collection('applications')
          .doc(application.userId)
          .update({'status': s});

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      application.status = last;
      notifyListeners();
    }
  }
}
