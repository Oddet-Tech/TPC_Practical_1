class ApplicationModel {
  final String? id; // allow Supabase to generate UUID
  final String userId;
  final int yearOfStudy;
  final String module1;
  final String module1Level;
  final String? module2;
  final String? module2Level;
  final bool isEligible;
  final String? documentUrl; // optional instead of requiered
  final String status;
  final DateTime createdAt;

  ApplicationModel({
    this.id,
    required this.userId,
    required this.yearOfStudy,
    required this.module1,
    required this.module1Level,
    this.module2,
    this.module2Level,
    required this.isEligible,
    this.documentUrl,
    required this.status,
    required this.createdAt,
  });

  //  from supabase to APP(The saved information in the 
  //database is in JSON format, so we need to
  // convert it to a Dart object that we can use in our app.)
  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id']?.toString(),
      userId: json['id']?.toString() ?? '',
      yearOfStudy: json['year_of_study'],
      module1: json['module_level'] ?? '',
      module1Level: json['module1_level'] ?? '',
      module2: null,
      module2Level: json['module2_level'],
      isEligible: json['is_eligible'] ?? false,
      documentUrl: json['document_url'],
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'year_of_study': yearOfStudy,
      'module_level': module1,
      'module1_level': module1Level,
      'module2_level': module2Level ?? '',
      'is_eligible': isEligible,
      'document_url': documentUrl,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}class UserModel {
  final String id;
  final String email;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.email,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      isAdmin: json['is_admin'] ?? false,
    );
  }

  String? get role => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'is_admin': isAdmin,
    };
  }
}