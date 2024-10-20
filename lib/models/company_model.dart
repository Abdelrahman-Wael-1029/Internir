class CompanyModel {
  /*
  Company Name, Email, Password, Phone, Address, Description, Image.
  */

  String id;
  String name;
  String email;
  String password;
  String phone;
  String address;
  String description;
  String? image;
  List<String> jobs;

  CompanyModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.description,
    this.image,
    required this.jobs,
  });

  CompanyModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? address,
    String? description,
    String? image,
    List<String>? jobs,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      description: description ?? this.description,
      image: image ?? this.image,
      jobs: jobs ?? this.jobs,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
        'description': description,
        'image': image,
        'jobs': jobs
      };

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        phone: json['phone'],
        address: json['address'],
        description: json['description'],
        image: json['image'],
        jobs: List<String>.from(json['jobs']??[]),
      );

  @override
  String toString() {
    return 'CompanyModel{id: $id, name: $name, email: $email, password: $password, phone: $phone, address: $address, description: $description, image: $image, jobs: $jobs}';
  }
}
