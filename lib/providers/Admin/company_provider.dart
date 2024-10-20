import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internir/models/job_model.dart';
import 'package:internir/services/fire_database.dart';

class CompanyProvider extends ChangeNotifier {
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
        },
      );

      // fetch company name
      var company = 'Google';
      await FireDatabase.updateData(
        'jobs',
        id!.id,
        {'id': id.id, 'company': company},
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateJob({
    required JobModel job,
  }) async {
    try {
      await FireDatabase.updateData(
        'jobs',
        job.id,
        job.toJson(),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteJob(String id) async {
    try {
      await FireDatabase.deleteData('jobs', id);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
