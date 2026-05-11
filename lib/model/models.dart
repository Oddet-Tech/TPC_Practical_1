class ApplicationModel {
  final String? id; // ✅ FIXED: allow Supabase to generate UUID
  final String userId;
  final int yearOfStudy;
  final String module1;
  final String module1Level;
  final String? module2;
  final String? module2Level;
  final bool isEligible;
  final String? documentUrl; // ✅ FIXED: optional instead of requi
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

  // 🔄 FROM SUPABASE → APP
  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id']?.toString(),
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

  // 🔄 APP → SUPABASE
  Map<String, dynamic> toJson() {
    return {
      // ❌ DO NOT send id (Supabase generates it)
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
}class UserModel {
  final String id;
  final String email;
  final String role;
  final String fullName;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.fullName,
  });

  // 🔄 Convert from Supabase JSON → Dart object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      fullName: json['full_name'],
    );
  }

  // 🔄 Convert Dart object → JSON (for DB if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'full_name': fullName,
    };
  }
}