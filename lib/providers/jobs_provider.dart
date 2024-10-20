import 'package:flutter/material.dart';
import 'package:internir/utils/utils.dart';
import '../models/job_model.dart';
import '../services/fire_database.dart';

class JobsProvider extends ChangeNotifier {
  int page = 0;
  int limit = 25;
  bool hasMore = true;
  var lastDocument, firstDocument;

  var allJobs = <JobModel>[];
  var jobs = <JobModel>[];
  bool loading = false;
  String category = '';

  var jobsByCategory = <JobModel>[];

  Future<dynamic> fetchData({
    bool isPrevious = false,
    bool isNext = false,
  }) async {
    return await FireDatabase.getData('jobs',
        orderBy: 'createdAt',
        descending: true,
        limit: limit,
        startAfterValue: isNext ? lastDocument['createdAt'] : null,
        endBeforeValue: isPrevious ? firstDocument['createdAt'] : null,
        isPrevious: isPrevious,
        filters: [
          ['enabled', [true], OperationFilter.whereIn.name],
        ]);
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void checkHasMore(lastData) {
    if (lastData.docs.length < limit || lastDocument == null) {
      hasMore = false;
    } else {
      hasMore = true;
    }
  }

  Future<void> fetchJobs() async {
    try {
      setLoading(true);
      allJobs = [];
      final data = await fetchData();

      for (final job in data.docs) {
        allJobs.add(JobModel.fromJson(job.data()));
      }

      jobs = allJobs;
      if (data.docs.isNotEmpty) {
        firstDocument = data.docs.first;
        lastDocument = data.docs.last;
      }

      checkHasMore(data);
    } catch (e) {
      debugPrint(e.toString());
      hasMore = false;
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }

  Future<void> nextPage() async {
    try {
      if (lastDocument != null && hasMore && loading == false) {
        setLoading(true);
        final nextPageData = await fetchData(isNext: true);

        if (nextPageData.docs.isNotEmpty) {
          firstDocument = nextPageData.docs.first;
          lastDocument = nextPageData.docs.last;
          page++;
        } else {
          hasMore = false;
          return;
        }

        allJobs = [];

        for (final job in nextPageData.docs) {
          allJobs.add(JobModel.fromJson(job.data()));
        }

        jobs = allJobs;

        checkHasMore(nextPageData);
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> previousPage() async {
    try {
      if (firstDocument != null && page > 0 && loading == false) {
        setLoading(true);
        final previousPageData = await fetchData(isPrevious: true);

        if (previousPageData.docs.isNotEmpty) {
          firstDocument = previousPageData.docs.first;
          lastDocument = previousPageData.docs.last;
          page--;
        } else {
          page = 0;
          return;
        }

        allJobs = [];

        for (final job in previousPageData.docs) {
          allJobs.add(JobModel.fromJson(job.data()));
        }

        jobs = allJobs;

        checkHasMore(previousPageData);
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshData() async {
    page = 0;
    firstDocument = null;
    lastDocument = null;
    await fetchJobs();
  }
}
