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

  CompanyModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.description,
    this.image,
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
      );

  @override
  String toString() {
    return 'CompanyModel{id: $id, name: $name, email: $email, password: $password, phone: $phone, address: $address, description: $description, image: $image}';
  }
}