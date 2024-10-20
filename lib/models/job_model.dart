class JobModel {
  String id;
  String title;
  String description;
  String location;
  DateTime createdAt;
  int numberOfApplicants;
  bool enabled;
  String company;
  double? salary;
  String? category;
  String? jobType;

  JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    this.salary,
    this.category,
    this.jobType,
    required this.company,
    required this.createdAt,
    required this.numberOfApplicants,
    required this.enabled,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      salary: (json['salary'] != null ? json['salary'] * 1.0 : null),
      category: json['category'],
      jobType: json['job type'],
      company: json['company'],
      createdAt: json['createdAt'].toDate().toLocal(),
      numberOfApplicants: json['number of applicants'],
      enabled: json['enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'salary': salary,
      'category': category,
      'job type': jobType,
      'company': company,
      'createdAt': createdAt.toString(),
      'number of applicants': numberOfApplicants,
      'enabled': enabled,
    };
  }

  JobModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    double? salary,
    String? category,
    String? jobType,
    String? company,
    DateTime? createdAt,
    int? numberOfApplicants,
    bool? enabled,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      category: category ?? this.category,
      company: company ?? this.company,
      jobType: jobType ?? this.jobType,
      createdAt: createdAt ?? this.createdAt,
      numberOfApplicants: numberOfApplicants ?? this.numberOfApplicants,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  String toString() {
    return 'JobModel{id: $id, title: $title, description: $description, location: $location, salary: $salary, category: $category, jobType: $jobType, company: $company, createdAt: $createdAt, numberOfApplicants: $numberOfApplicants, enabled: $enabled}';
  }
}