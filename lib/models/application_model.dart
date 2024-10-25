class ApplicationModel {
  String username;
  String email;
  String phone;
  DateTime appliedAt;
  String status;
  String jobId;
  String jobTitle;
  String userId;
  String category;
  String? resume;

  ApplicationModel({
    required this.email,
    required this.phone,
    required this.jobId,
    required this.jobTitle,
    required this.appliedAt,
    required this.status,
    required this.userId,
    required this.username,
    required this.category,
    this.resume,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'jobId': jobId,
        'jobTitle': jobTitle,
        'appliedAt': appliedAt,
        'status': status,
        'userId': userId,
        'username': username,
        'resume': resume,
        'category': category,
      };

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      ApplicationModel(
        email: json['email'],
        phone: json['phone'],
        jobId: json['jobId'],
        jobTitle: json['jobTitle'],
        appliedAt: json['appliedAt'].toDate().toLocal(),
        status: json['status'],
        userId: json['userId'],
        username: json['username'],
        category: json['category'],
        resume: json['resume'],
      );

  @override
  String toString() {
    return 'ApplicationModel(email: $email, phone: $phone, jobId: $jobId, jobTitle: $jobTitle, appliedAt: $appliedAt, status: $status, userId: $userId, username: $username, category: $category, resume: $resume)';
  }
}
