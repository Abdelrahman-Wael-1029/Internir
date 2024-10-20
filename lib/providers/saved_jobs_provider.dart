import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobSaveProvider with ChangeNotifier {
  final List<String> _savedJobs = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _docId = 'saved_jobs';

  JobSaveProvider() {
    _loadSavedJobs();
  }

  bool isJobSaved(String jobId) {
    return _savedJobs.contains(jobId);
  }

  void toggleSaveJob(String jobId) {
    if (isJobSaved(jobId)) {
      _savedJobs.remove(jobId);
    } else {
      _savedJobs.add(jobId);
    }
    _saveJobs();
    notifyListeners();
  }

  List<String> get savedJobs => _savedJobs;

  void _saveJobs() async {
    await _firestore.collection('jobs').doc(_docId).set({
      'savedJobs': _savedJobs,
    });
  }

  void _loadSavedJobs() async {
    DocumentSnapshot doc = await _firestore.collection('jobs').doc(_docId).get();
    if (doc.exists) {
      List<String> savedJobs = List<String>.from(doc['savedJobs']);
      _savedJobs.addAll(savedJobs);
      notifyListeners();
    }
  }
}
