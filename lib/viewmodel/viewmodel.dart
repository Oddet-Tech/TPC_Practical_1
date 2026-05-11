// Student Numbers: 223021599
// Student Names  : Brandon Lombaard
// Question: Application ViewModel

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

  Future<void> logout() async {
    await _authService.signOut();
    currentUser = null;
    applications = [];
    notifyListeners();
  }

  // Fetches the user profile row from the 'users' table using the auth UID.
  Future<void> _loadCurrentUser() async {
    final authUser = _authService.getCurrentUser();
    if (authUser == null) return;

    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', authUser.id)
        .single();

    currentUser = UserModel.fromJson(response);
    notifyListeners();
  }

  Future<void> fetchUserApplications(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

   final response = await Supabase.instance.client
       .from('applications')
       .select()
       .eq('user_id', userId);

    if (response.error == null) {
      applications = (response.data as List)
         .map((data) => ApplicationModel.fromJson(data))
         .toList();
    } else {
      // handle error
      applications = [];
      errorMessage = 'Failed to load applications: ${response.error!.message}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createApplication(ApplicationModel app) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.createApplication(app);
    } catch (e) {
      errorMessage = 'Failed to submit application.';
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> updateApplication(ApplicationModel app) async {
    await _service.updateApplication(app);
  }

  Future<void> deleteApplication(String id) async {
    await _service.deleteApplication(id);
    applications.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  Future<void> fetchAllApplications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      applications = await _service.getAllApplications();
    } catch (e) {
      errorMessage = 'Failed to load applications.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStatus(String id, String status) async {
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
      notifyListeners();
    }
  }

  Future<bool> hasExistingApplication(String userId) async {
    final userApps = await _service.getUserApplications(userId);
    return userApps.isNotEmpty;
  }
}
