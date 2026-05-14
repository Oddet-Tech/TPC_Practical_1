import 'package:final_tpg_project_p1/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/models.dart';
import '../services/application_service.dart';

class ApplicationViewModel extends ChangeNotifier {
  final ApplicationService _service = ApplicationService();
  final AuthService _authService = AuthService();

  List<ApplicationModel> applications = [];

  bool isLoading = false;
  bool isSubmitting = false;

  String? errorMessage;
  UserModel? currentUser;

  String get userRole => currentUser?.role ?? '';
  bool get isAdmin => userRole == 'admin';
  bool get isAuthenticated => currentUser != null;

  // ========================= LOGIN =========================
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.signIn(email, password);
      await _loadCurrentUser();
      return true;
    } catch (e) {
      errorMessage = 'Login failed. Check your credentials.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ========================= LOGOUT =========================
  Future<void> logout() async {
    try {
      await _authService.signOut();
      currentUser = null;
      applications = [];
    } catch (e) {
      errorMessage = 'Logout failed: $e';
    }
    notifyListeners();
  }

  // ========================= LOAD USER =========================
  Future<void> _loadCurrentUser() async {
    try {
      final authUser = _authService.getCurrentUser();
      if (authUser == null) return;

      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', authUser.id)
          .single();

      currentUser = UserModel.fromJson(response);
    } catch (e) {
      errorMessage = 'Failed to load current user: $e';
    }

    notifyListeners();
  }

  // ========================= FETCH USER APPLICATIONS =========================
  Future<void> fetchUserApplications(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      applications = await _service.getUserApplications(userId);
    } catch (e) {
      applications = [];
      errorMessage = 'Failed to load applications: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ========================= CREATE =========================
  Future<void> createApplication(ApplicationModel app) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.createApplication(app);

      // 🔥 FIX: refresh list after insert
      await fetchUserApplications(app.userId);
    } catch (e) {
      errorMessage = 'Failed to submit application: $e';
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ========================= UPDATE =========================
  Future<void> updateApplication(ApplicationModel app) async {
    try {
      await _service.updateApplication(app);

      // 🔥 FIX: refresh instead of silent update
      await fetchUserApplications(app.userId);
    } catch (e) {
      errorMessage = 'Failed to update application: $e';
      notifyListeners();
    }
  }

  // ========================= DELETE =========================
  Future<void> deleteApplication(String id) async {
    try {
      await _service.deleteApplication(id);

      applications.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to delete application: $e';
      notifyListeners();
    }
  }

  // ========================= FETCH ALL =========================
  Future<void> fetchAllApplications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      applications = await _service.getAllApplications();
    } catch (e) {
      errorMessage = 'Failed to load applications: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ========================= UPDATE STATUS =========================
  Future<void> updateStatus(String id, String status) async {
    try {
      await _service.updateStatus(id, status);

      final index = applications.indexWhere((a) => a.id == id);

      if (index != -1) {
        applications[index] = ApplicationModel(
          id: applications[index].id,
          userId: applications[index].userId,
          yearOfStudy: applications[index].yearOfStudy,
          module1: applications[index].module1,
          module1Level: applications[index].module1Level,
          module2: applications[index].module2,
          module2Level: applications[index].module2Level,
          isEligible: applications[index].isEligible,
          documentUrl: applications[index].documentUrl,
          status: status,
          createdAt: applications[index].createdAt,
        );
      }

      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to update status: $e';
      notifyListeners();
    }
  }

  // ========================= CHECK EXISTING =========================
  Future<bool> hasExistingApplication(String userId) async {
    try {
      final userApps = await _service.getUserApplications(userId);
      return userApps.isNotEmpty;
    } catch (e) {
      errorMessage = 'Failed to check application: $e';
      notifyListeners();
      return false;
    }
  }
}