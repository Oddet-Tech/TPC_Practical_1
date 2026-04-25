class UserModel { //Blueprint for User or Admin,Helps Identify both And direct them to right pages through role
  final String id;
  final String email;
  final String role;
  final String fullName;

  UserModel({
    required this.id,//it has to be there,it's required
    required this.email,//Same
    required this.role,//Same
    required this.fullName,//Same
  });

  factory UserModel.fromJson(Map<String, dynamic> json) { //A special Constructor
    return UserModel(// this will take Each data that is created by user to the database
      id: json['id'],
      email: json['email'],
      role: json['role'],
      fullName: json['full_name'],
    );
  }

  Map<String, dynamic> toJson() {//Retrieve information from database and display it to user
    return {//CRUD methods
      'id': id,
      'email': email,
      'role': role,
      'full_name': fullName,
    };
  }
}
class ApplicationModel {//Application Information with the Same Idea of User/Admin information
  final String id;
  final String userId;
  final int yearOfStudy;
  final String module1;
  final String module1Level;
  final String? module2;
  final String? module2Level;
  final bool isEligible;
  final String documentUrl;
  final String status;
  final DateTime createdAt;

  ApplicationModel({
    required this.id,
    required this.userId,
    required this.yearOfStudy,
    required this.module1,
    required this.module1Level,
    this.module2,
    this.module2Level,
    required this.isEligible,
    required this.documentUrl,
    required this.status,
    required this.createdAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      userId: json['user_id'],
      yearOfStudy: json['year_of_study'],
      module1: json['module1'],
      module1Level: json['module1_level'],
      module2: json['module2'],
      module2Level: json['module2_level'],
      isEligible: json['is_eligible'],
      documentUrl: json['document_url'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'year_of_study': yearOfStudy,
      'module1': module1,
      'module1_level': module1Level,
      'module2': module2,
      'module2_level': module2Level,
      'is_eligible': isEligible,
      'document_url': documentUrl,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}